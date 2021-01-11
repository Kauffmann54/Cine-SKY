//
//  Cine_SKYTests.swift
//  Cine_SKYTests
//
//  Created by Guilherme Kauffmann on 11/01/21.
//

import XCTest
@testable import Cine_SKY

class Cine_SKYTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMovieIdViewModel() {
        let movieIdViewModel = MovieIdViewModel()
        let moviesExpectation = expectation(description: "Lista de IDs de filmes")
        var moviesIds = Array<String>()
        movieIdViewModel.bindMoviesViewModelToController = {
            moviesIds = movieIdViewModel.moviesIdList
            if moviesIds.count == 0
            {
                XCTFail("Falha na recuperação da lista de IDs dos filmes")
            }
            moviesExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(moviesIds)
        }
    }
    
    func testRetriveMovieDetail() {
        let apiService = APIService()
        let moviesExpectation = expectation(description: "Verificar o retorno dos detalhes do filme selecionado")
        apiService.getOverviewDetails(movieId: "tt0944947") { (result) in
            switch result {
            case.success(let movieAux):
                let movie = (movieAux as! Movie)
                XCTAssertNotNil(movie, "Os detalhes do filme foram retornados")
                moviesExpectation.fulfill()
                break
            case .failure(let error):
                XCTFail("Falha na recuperação do filme " + error.localizedDescription)
                break
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            
        }
    }
    
    func testMovieViewModel() {
        let apiService = APIService()
        let moviesExpectation = expectation(description: "Comparar os IDs para verificar se houve alteração")
        apiService.getOverviewDetails(movieId: "tt0944947") { (result) in
            switch result {
            case.success(let movieAux):
                let movie = (movieAux as! Movie)
                let movieViewModel = MovieViewModel(movie: movie)
                XCTAssertEqual(movie.id, movieViewModel.id)
                moviesExpectation.fulfill()
                break
            case .failure(let error):
                XCTFail("Falha na recuperação do filme " + error.localizedDescription)
                break
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            
        }
    }
    
    func testExpectedURLHostAndPaths() {
        let apiService = APIService()
        XCTAssertEqual(apiService.rapidapi_host, "imdb8.p.rapidapi.com")
        XCTAssertEqual(apiService.mostPopularMoviesPath, "title/get-most-popular-movies")
        XCTAssertEqual(apiService.overviewDetailsPath, "title/get-overview-details")
        XCTAssertEqual(apiService.videosPath, "title/get-videos")
        XCTAssertEqual(apiService.VideoPlaybackPath, "title/get-video-playback")
    }

    func testRetriveVideos() {
        let apiService = APIService()
        let moviesExpectation = expectation(description: "Verificar se os vídeos do filme selecionado foram retornados")
        apiService.getVideos(movieId: "tt0944947") { (result) in
            switch result {
            case.success(let videosAux):
                let videos = (videosAux as! Video)
                XCTAssertNotNil(videos, "A lista de vídeos foram retornados")
                moviesExpectation.fulfill()
                break
            case .failure(let error):
                XCTFail("Falha na recuperação do vídeo do filme " + error.localizedDescription)
                break
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            
        }
    }
    
    func testRetriveVideoPlayback() {
        let apiService = APIService()
        let moviesExpectation = expectation(description: "Verificar se o link do vídeo foi retornado")
        apiService.getVideoPlayback(videoId: "vi1015463705") { (result) in
            switch result {
            case.success(let videoPlaybackAux):
                let videoPlayback = (videoPlaybackAux as! VideoPlayback)
                XCTAssertNotNil(videoPlayback, "O Playback do vídeo foi retornado")
                XCTAssertNotEqual(videoPlayback.resource.encodings.first?.playUrl, "", "O link foi retornado")
                moviesExpectation.fulfill()
                break
            case .failure(let error):
                XCTFail("Falha na recuperação do vídeo do filme " + error.localizedDescription)
                break
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            
        }
    }
    
    func testDetailViewModel() {
        let imageExpectation = expectation(description: "Espera receber a URL da imagem")
        let videoExpectation = expectation(description: "Espera receber a URL do vídeo")
        let detailViewModel = DetailViewModel(movieId: "tt0944947")
        detailViewModel.bindDetailViewModelToController = {
            if detailViewModel.videoImage != nil {
                XCTAssertNotNil(detailViewModel.videoImage, "URL da imagem do vídeo recuperado")
                imageExpectation.fulfill()
            } else {
                XCTFail("Falha na recuperação da URL da imagem do vídeo")
            }
            
            if detailViewModel.videoURL != nil {
                XCTAssertNotNil(detailViewModel.videoURL, "URL do vídeo recuperado")
                videoExpectation.fulfill()
            } else {
                XCTFail("Falha na recuperação da URL do vídeo")
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            
        }
    }
}
