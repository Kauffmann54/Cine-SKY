//
//  MovieIdViewModel.swift
//  Cine SKY
//
//  Created by Guilherme Kauffmann on 10/01/21.
//

import Foundation

class MovieIdViewModel : NSObject {
    
    // MARK: - Properties
    private var apiService : APIService!
    private(set) var moviesIdList = Array<String>() {
        didSet {
            self.bindMoviesViewModelToController()
        }
    }
    
    var bindMoviesViewModelToController : (() -> ()) = {}
    
    /// Initializes API and retrieves ID list of most popular movies
    override init() {
        super.init()
        self.apiService = APIService()
        getMoviesIds()
    }
    
    /// Recovers movie IDs using API Service
    func getMoviesIds() {
        self.apiService.getMostPopularMovies{ (result) in
            switch result {
                case .success(let moviesIds):
                    self.moviesIdList = (moviesIds as! Array<String>)
                    break
                case .failure(_):
                    self.moviesIdList = Array<String>()
                    Alert.showErrorAlert(message: "Não foi possível recuperar a lista de filmes")
                    break
                }
        }
    }
}
