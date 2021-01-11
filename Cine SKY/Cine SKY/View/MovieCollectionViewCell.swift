//
//  MovieCollectionViewCell.swift
//  Cine SKY
//
//  Created by Guilherme Kauffmann on 10/01/21.
//

import UIKit
import Lottie
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
        
    // MARK: - Outlets
    @IBOutlet var bannerButton: UIButton!
    @IBOutlet var bannerImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: - Properties
    static let cellIdentifier = "MovieCollectionViewCell"
    var animationView: AnimationView!
    var apiService: APIService!
    var movie: MovieViewModel!
        
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.apiService = APIService()
        
        let jsonName = "loading"
        let animation = Animation.named(jsonName)

        animationView = AnimationView(animation: animation)
        animationView.frame = loadingView.bounds
        animationView.loopMode = .loop
        animationView.contentMode = .scaleToFill
        loadingView.addSubview(animationView)
        animationView.play()
        loadingView.layer.cornerRadius = loadingView.frame.width / 2.0
        loadingView.layer.masksToBounds = true
        
        loadingView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        loadingView.layer.shadowRadius = 3
        loadingView.layer.shadowOpacity = 0.5
    }
    
    // MARK: - Functions
    
    /// Search the film details to configure cell
    ///
    /// - Parameter movieId: The selected movie ID
    /// - Parameter movieViewModel: To retrive an existent object or download new
    public func configure(with movieId: String, movieViewModel: MovieViewModel?, completion: @escaping (MovieViewModel) -> Void) {
        updateUI(movie: nil)
        if movieViewModel != nil {
            updateUI(movie: movieViewModel)
        } else {
            apiService.getOverviewDetails(movieId: movieId) { [self] (result) in
                switch result {
                case .success(let movieDetail):
                    self.movie = MovieViewModel(movie: movieDetail as! Movie)
                    self.updateUI(movie: self.movie)
                    completion(self.movie)
                    break
                case .failure( _):
                    //Alert.showErrorAlert(message: "Não foi possível recuperar os detalhes deste filme")
                    break
                }
            }
        }
    }
    
    /// Updates cell with movie details
    ///
    /// - Parameter movie: Object to be inserted in the cell
    public func updateUI(movie: MovieViewModel?) {
        self.bannerButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.bannerButton.layer.shadowRadius = 5
        self.bannerButton.layer.shadowOpacity = 0.5
        
        if movie == nil {
            self.title.isSkeletonable = true
            self.title.showAnimatedGradientSkeleton()
            self.bannerImage.isSkeletonable = true
            self.bannerImage.showAnimatedGradientSkeleton()
            self.title.text = ""
            self.bannerImage.image = nil
            self.loadingView.isHidden = false
        } else {
            self.title.hideSkeleton()
            self.bannerImage.hideSkeleton()
            self.title.text = movie!.detail.title
            self.loadingView.isHidden = false
            self.bannerImage.sd_setImage(with: URL(string: movie!.detail.image.url)) { (image, error, sdImage, url) in
                self.loadingView.isHidden = true
            }
        }
    }
    

}
