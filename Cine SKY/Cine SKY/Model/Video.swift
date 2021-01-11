//
//  Video.swift
//  Cine SKY
//
//  Created by Guilherme Kauffmann on 10/01/21.
//

import Foundation

struct Video: Decodable {
  let resource: Resource
}

struct Resource: Decodable {
    let image: Image
    let videos: [Videos]
}

struct Videos: Decodable {
    let contentType: String
    let id: String
}
