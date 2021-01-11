//
//  APIService.swift
//  Cine SKY
//
//  Created by Guilherme Kauffmann on 10/01/21.
//

import Alamofire

enum Result {
  case success(Any)
  case failure(Error)
}

class APIService: NSObject {    
    let rapidapi_key = "3ab362fec9msh897b9202f6debedp116d4bjsn14f02d476d5e"
    let rapidapi_host = "imdb8.p.rapidapi.com"
    let apiURL = "https://imdb8.p.rapidapi.com"
    let mostPopularMoviesPath = "title/get-most-popular-movies"
    let overviewDetailsPath = "title/get-overview-details"
    let videosPath = "title/get-videos"
    let VideoPlaybackPath = "title/get-video-playback"
    
    /// Creates the base API URL
     private lazy var baseURL: URL = {
       guard let url = URL(string: apiURL) else {
         fatalError("Invalid URL")
       }
       return url
     }()
  
    
    /// Retrieves the list with the most popular movie IDs
    ///
    /// - Returns: `Result` Returns the result of the request
    func getMostPopularMovies(completion: @escaping (Result) -> Void) {
        let url = baseURL.appendingPathComponent(mostPopularMoviesPath)
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key": rapidapi_key,
            "x-rapidapi-host": rapidapi_host
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    let array = json as! Array<String>
                    completion(Result.success(array))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
    }
    
    /// Retrieves the details of the selected movie
    ///
    /// - Parameter movieId: Selected movie ID
    /// - Returns: `Result` Returns the result of the request
    func getOverviewDetails(movieId: String, completion: @escaping (Result) -> Void) {
        let url = baseURL.appendingPathComponent(overviewDetailsPath)
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key": rapidapi_key,
            "x-rapidapi-host": rapidapi_host
        ]
        
        let params: [String: Any] = [
            "tconst": movieId
        ]
        
        AF.request(url, method: .get, parameters: params, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    do {
                        let jsonDecode = try JSONDecoder().decode(Movie.self, from: response.data!)
                        completion(Result.success(jsonDecode))
                    } catch let error {
                        completion(Result.failure(error))
                    }
                    break
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
    }
    
    /// Retrieves the IDs and video types of the selected movie
    ///
    /// - Parameter movieId: Selected movie ID
    /// - Returns: `Result` Returns the result of the request
    func getVideos(movieId: String, completion: @escaping (Result) -> Void) {
        let url = baseURL.appendingPathComponent(videosPath)
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key": rapidapi_key,
            "x-rapidapi-host": rapidapi_host
        ]
        
        let params: [String: Any] = [
            "tconst": movieId,
            "limit": 200
        ]
        
        AF.request(url, method: .get, parameters: params, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    do {
                        let jsonDecode = try JSONDecoder().decode(Video.self, from: response.data!)
                        completion(Result.success(jsonDecode))
                    } catch let error {
                        completion(Result.failure(error))
                    }
                    break
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
    }
    
    /// Retrieves the URLs of the selected video
    ///
    /// - Parameter videoId: Selected video ID
    /// - Returns: `Result` Returns the result of the request
    func getVideoPlayback(videoId: String, completion: @escaping (Result) -> Void) {
        let url = baseURL.appendingPathComponent(VideoPlaybackPath)
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key": rapidapi_key,
            "x-rapidapi-host": rapidapi_host
        ]
        
        let params: [String: Any] = [
            "viconst": videoId
        ]
        
        AF.request(url, method: .get, parameters: params, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    do {
                        let jsonDecode = try JSONDecoder().decode(VideoPlayback.self, from: response.data!)
                        completion(Result.success(jsonDecode))
                    } catch let error {
                        completion(Result.failure(error))
                    }
                    break
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
    }
    
}
