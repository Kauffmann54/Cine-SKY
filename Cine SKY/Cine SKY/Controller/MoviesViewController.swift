//
//  MoviesViewController.swift
//  Cine SKY
//
//  Created by Guilherme Kauffmann on 10/01/21.
//

import UIKit
import AVKit
import Lottie
import SkeletonView

class MoviesViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var loadingBackground: UIVisualEffectView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    // MARK: - Properties
    private var movieViewModel: MovieIdViewModel!
    var selectedMovieId: String!
    var movieList = [MovieViewModel]()
    let limitMovies: Int = 30
    var timer = Timer()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesCollectionView.register(UINib.init(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.cellIdentifier)
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        
        let animationCinema = Animation.named("loadingPlay")
        
        var animationMovieView: AnimationView!
        animationMovieView = AnimationView(animation: animationCinema)
        animationMovieView.frame = loadingView.bounds
        animationMovieView.loopMode = .loop
        animationMovieView.contentMode = .scaleToFill
        loadingView.addSubview(animationMovieView)
        animationMovieView.play()
        loadingView.layer.cornerRadius = loadingView.frame.width / 2.0
        loadingView.layer.masksToBounds = true
        
        callToViewModelForUIUpdate()
    }
    
    // MARK: - Funtions
    
    /// Initializes ViewModel and waits for data return to update CollectionView
    @objc func callToViewModelForUIUpdate(){
        self.loadingBackground.isHidden = false
        self.movieViewModel = MovieIdViewModel()
        self.movieViewModel.bindMoviesViewModelToController = {
            self.loadingBackground.isHidden = true
            if self.movieViewModel.moviesIdList.count == 0 {
                self.getMoviesList()
            } else {
                self.moviesCollectionView.reloadData()
            }
        }
    }
    
    /// If it is not possible to retrieve the list of movie IDs, every 10 seconds a new attempt is made
    func getMoviesList() {
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.callToViewModelForUIUpdate), userInfo: nil, repeats: false)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.selectedMovieId = selectedMovieId
        }
    }

}

// MARK: - UICollectionViewDelegate

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovieId = movieViewModel.moviesIdList[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
}


// MARK: - UICollectionViewDataSource

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movieViewModel.moviesIdList.count == 0 {
            noResultsLabel.isHidden = false
        } else {
            noResultsLabel.isHidden = true
        }
        
        if movieViewModel.moviesIdList.count > limitMovies {
            return limitMovies
        }
        return movieViewModel.moviesIdList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.cellIdentifier, for: indexPath) as! MovieCollectionViewCell
        let movieId = self.movieViewModel.moviesIdList[indexPath.row].replacingOccurrences(of: "/title/", with: "").replacingOccurrences(of: "/", with: "")
        var movieFind: MovieViewModel?
        for movieItem in movieList {
            if movieItem.id == movieId {
                movieFind = movieItem
                break
            }
        }
        cell.configure(with: movieId, movieViewModel: movieFind) { (movie) in
            self.movieList.append(movie)
        }
        
        return cell
    }
    
}
