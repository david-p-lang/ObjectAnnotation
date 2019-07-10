//
//  JSONStructs.swift
//  Annotate
//
//  Created by David Lang on 7/9/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import Foundation

struct FlickrSearchResult: Codable {
    let photos: FlickrPagesResult?
    let stat: String
}

struct FlickrPagesResult: Codable {
    let photo: [FlickrUrl]
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
}

struct FlickrUrl: Codable {
    let id: String
    let farm: Int
    let owner: String
    let secret: String
    let server: String
    let title: String
}
