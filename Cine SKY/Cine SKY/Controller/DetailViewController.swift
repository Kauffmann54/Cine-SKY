//
//  DetailViewController.swift
//  Cine SKY
//
//  Created by Guilherme Kauffmann on 10/01/21.
//

import UIKit
import Cosmos
import Lottie
import SDWebImage
import AVKit

class DetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var bannerVideo: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UITextView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var loadingMovieView: UIView!
    @IBOutlet weak var loadingBackground: UIVisualEffectView!
    
    
    // MARK: - Properties
    
    private var detailViewModel: DetailViewModel!
    var animationView: AnimationView!
    var animationMovieView: AnimationView!
    var selectedMovieId: String!
    var videoURL: String = ""
    let playerController = AVPlayerViewController()
    var timer = Timer()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingBackground.isHidden = false
        backgroundView.roundCorners(desiredCurve: CGFloat(0.6))
        backgroundView.backgroundColor = #colorLiteral(red: 0.9004352689, green: 0.01954406686, blue: 0.01716371439, alpha: 1)
        self.backgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.backgroundView.layer.shadowRadius = 5
        self.backgroundView.layer.shadowOpacity = 0.5
        
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
        
        
        let animationCinema = Animation.named("loadingPlay")
        
        animationMovieView = AnimationView(animation: animationCinema)
        animationMovieView.frame = loadingMovieView.bounds
        animationMovieView.loopMode = .loop
        animationMovieView.contentMode = .scaleToFill
        loadingMovieView.addSubview(animationMovieView)
        animationMovieView.play()
        loadingMovieView.layer.cornerRadius = loadingMovieView.frame.width / 2.0
        loadingMovieView.layer.masksToBounds = true
        
        callToViewModelForUIUpdate()
    }
    
    // MARK: - Button
    
    @IBAction func playVideo(_ sender: Any) {
        try! AVAudioSession.sharedInstance().setCategory(.playback)

        let player = AVPlayer(url: URL(string: videoURL)!)
        playerController.player = player
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerController.player?.currentItem)

        present(playerController, animated: true) {
            player.play()
        }
    }
    
    // MARK: - Funtions
    
    @objc func callToViewModelForUIUpdate() {
        self.loadingBackground.isHidden = false
        self.detailViewModel = DetailViewModel(movieId: selectedMovieId)
        self.detailViewModel.bindDetailViewModelToController = {
            if self.detailViewModel.movieViewModel != nil {
                self.loadingBackground.isHidden = true
                /// Insert movie data
                self.title = self.detailViewModel.movieViewModel!.detail.title
                self.ratingView.settings.fillMode = .precise
                self.ratingView.settings.updateOnTouch = false
                self.ratingView.rating = self.detailViewModel.movieViewModel!.rating.rating!/2
                self.ratingLabel.text = "(IMDb) \(self.detailViewModel.movieViewModel!.rating.rating!)/10"
                self.titleLabel.text = self.detailViewModel.movieViewModel!.detail.title
                self.durationLabel.text = "\(self.detailViewModel.movieViewModel!.detail.runningTimeInMinutes ?? 0) min"
                self.yearLabel.text = self.detailViewModel.movieViewModel?.year
                self.genreLabel.text = ""
                var qtdGenres: Int = 0
                self.detailViewModel.movieViewModel!.genres.genres.forEach { (genre) in
                    self.genreLabel.text?.append("\(genre)")
                    if qtdGenres < self.detailViewModel.movieViewModel!.genres.genres.count - 1 {
                        self.genreLabel.text?.append(", ")
                    }
                    qtdGenres += 1
                }
                self.overviewLabel.text = self.detailViewModel.movieViewModel?.plotSummary
                /////////////////////////
                
                self.retriveVideo()
            } else {
                self.getMovieDetails()
                self.loadingMovieView.isHidden = true
            }
        }
    }
    
    @objc func retriveVideo() {
        self.detailViewModel.bindDetailVideoViewModelToController = {
            if self.detailViewModel.videoURL != nil {
                self.bannerVideo.sd_setImage(with: URL(string: self.detailViewModel.videoImage!), completed: nil)
                self.videoURL = self.detailViewModel.videoURL!
                
                self.loadingView.isHidden = true
            } else {
                self.getVideo()
            }
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        playerController.dismiss(animated: true, completion: nil)
    }
    
    /// If it is not possible to retrieve the movie details, every 10 seconds a new attempt is made
    func getMovieDetails() {
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.callToViewModelForUIUpdate), userInfo: nil, repeats: false)
    }
    
    /// If it is not possible to retrieve the movie video, every 10 seconds a new attempt is made
    func getVideo() {
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.retriveVideo), userInfo: nil, repeats: false)
    }    
}


extension UIView {
    func roundCorners(desiredCurve:CGFloat?) {
        let offset:CGFloat = self.frame.width/desiredCurve!
        let bounds: CGRect = self.bounds
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y+bounds.size.height / 2, width: bounds.size.width, height: bounds.size.height / 2)
            let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
            let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
            let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
            rectPath.append(ovalPath)

            let maskLayer: CAShapeLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = rectPath.cgPath

            self.layer.mask = maskLayer
    }
}
