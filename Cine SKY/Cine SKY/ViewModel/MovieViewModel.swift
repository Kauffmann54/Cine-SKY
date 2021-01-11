//
//  MovieViewModel.swift
//  Cine SKY
//
//  Created by Guilherme Kauffmann on 10/01/21.
//

import Foundation

class MovieViewModel {
    
    let id: String
    let detail: Title
    let rating: Ratings
    let genres: Genres
    let plotSummary: String
    let year: String
      
    
    init(movie: Movie) {
        self.id = movie.id.replacingOccurrences(of: "/title/", with: "").replacingOccurrences(of: "/", with: "")
        self.detail = movie.detail
        if movie.rating?.rating == nil {
            self.rating = Ratings(rating: 0.0)
        } else {
            self.rating = movie.rating!
        }
        
        
        self.genres = movie.genres
        self.plotSummary = movie.plotSummary?.text ?? movie.plotOutline.text
        
        if detail.seriesStartYear != nil {
            let endYear = detail.seriesEndYear ?? 0
            let endYearText: String = endYear == 0 ? "" : String(endYear)
            self.year = "\(detail.seriesStartYear!) - \(endYearText)"
        } else {
            self.year = "\(detail.year)"
        }
    }
}
