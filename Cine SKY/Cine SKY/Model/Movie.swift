//
//  Movie.swift
//  Cine SKY
//
//  Created by Guilherme Kauffmann on 10/01/21.
//

import Foundation

struct Movie: Decodable {
  let id: String
  let detail: Title
  let rating: Ratings?
  let genres: Genres
  let plotSummary: PlotSummary?
  let plotOutline: PlotOutline
    
    enum CodingKeys: String, CodingKey {
        case id
        case detail = "title"
        case rating = "ratings"
        case genres
        case plotSummary
        case plotOutline
    }
}


struct Title: Decodable {
    let image: Image
    let runningTimeInMinutes: Int?
    let numberOfEpisodes: Int?
    let seriesEndYear: Int?
    let seriesStartYear: Int?
    let year: Int
    let title: String
}

struct Image: Decodable {
    let url: String
}

struct Ratings: Decodable {
    let rating: Double?
}

struct Genres: Decodable {
    let genres: Array<String>
        
    enum CodingKeys: String, CodingKey {
        case genres
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var genresAux = Array<String>()
        while !container.isAtEnd {
            genresAux.append(try container.decode(String.self))
        }
        genres = genresAux
    }
}

struct PlotSummary: Decodable {
    let text: String
}

struct PlotOutline: Decodable {
    let text: String
}
