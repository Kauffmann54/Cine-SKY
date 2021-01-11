//
//  VideoPlayback.swift
//  Cine SKY
//
//  Created by Guilherme Kauffmann on 10/01/21.
//

import Foundation

struct VideoPlayback: Decodable {
  let resource: VideoDetail
}

struct VideoDetail: Decodable {
    let encodings: [Encodings]
}

struct Encodings: Decodable {
    let playUrl: String
}
