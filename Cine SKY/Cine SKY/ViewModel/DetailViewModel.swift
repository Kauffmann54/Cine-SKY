//
//  DetailViewModel.swift
//  Cine SKY
//
//  Created by Guilherme Kauffmann on 11/01/21.
//

import Foundation

class DetailViewModel : NSObject {
    
    // MARK: - Properties
    private var apiService : APIService!
    private var movieId: String!
    private(set) var movieViewModel: MovieViewModel? {
        didSet {
            self.bindDetailViewModelToController()
        }
    }
    
    private(set) var videoImage: String? {
        didSet {
            self.bindDetailVideoViewModelToController()
        }
    }
    
    private(set) var videoURL: String? {
        didSet {
            self.bindDetailVideoViewModelToController()
        }
    }
    
    var bindDetailViewModelToController : (() -> ()) = {}
    var bindDetailVideoViewModelToController : (() -> ()) = {}
    
    /// Initializes API, retrieves movie details and video
    init(movieId: String) {
        super.init()
        self.movieId = movieId.replacingOccurrences(of: "/title/", with: "").replacingOccurrences(of: "/", with: "")
        self.apiService = APIService()
        self.getMovieDetail()
    }
    
    /// Recovers movie details using API Service
    func getMovieDetail() {
        self.apiService.getOverviewDetails(movieId: self.movieId) { (result) in
            switch result {
                case .success(let movie):
                    self.movieViewModel = MovieViewModel(movie: movie as! Movie)
                    self.getVideoList() /// Retrieves video list of selected movie
                    break
                case .failure(_):
                    self.movieViewModel = nil
                    Alert.showErrorAlert(message: "Não foi possível recuperar os detalhes deste filme")
                    break
                }
        }
    }
    
    /// Recovers video list
    func getVideoList() {
        self.apiService.getVideos(movieId: self.movieId) { (result) in
            switch result {
                case .success(let video):
                    self.getVideoPlayback(video: video as! Video)
                    break
                case .failure( _):
                    Alert.showErrorAlert(message: "Não foi possível o vídeo deste filme")
                    break
            }
        }
    }
    
    /// Search the received videos if you have any Trailer or Clip videos, then retrieve the video link to be displayed
    ///
    /// - Parameter video: List of all videos
    func getVideoPlayback(video: Video) {
        for videoItem in video.resource.videos {
            if videoItem.contentType == "Trailer" || videoItem.contentType == "Clip" {
                self.apiService.getVideoPlayback(videoId: videoItem.id.replacingOccurrences(of: "/videoV2/", with: "")) { (result) in
                    switch result {
                    case .success(let playback):
                        let videoPlayback = playback as! VideoPlayback
                        if videoPlayback.resource.encodings.first != nil {
                            self.videoImage = video.resource.image.url
                            self.videoURL = videoPlayback.resource.encodings.first?.playUrl ?? ""
                        }
                        break
                    case .failure( _):
                        Alert.showErrorAlert(message: "Não foi possível o vídeo deste filme")
                    break
                    }
                }
                break
            }
        }
    }
}
