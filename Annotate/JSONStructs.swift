//
//  JSONStructs.swift
//  Annotate
//
//  Created by David Lang on 7/9/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import Foundation

struct FlickrErrorResult: Codable {
    let stat: String
    let code: Int
    let message: String
}

struct FlickrSearchResult: Codable {
    let photos: FlickrPagesResult?
    let stat: String
}

struct FlickrPagesResult: Codable {
    let photo: [FlickrUrl]
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
}

struct FlickrUrl: Codable {
    let id: String
    let farm: Int
    let owner: String
    let secret: String
    let server: String
    let title: String
}

struct AllAnnotations: Codable {
    let imageInfoSet: [ImageInfo]
}

struct ImageInfo : Codable {
    let image: String
    let annotations : [Annotation]
}

struct Annotation : Codable {
    let label: String
    let coordinates: Coordinates
}

struct Coordinates: Codable {
    let x: Int
    let y: Int
    let width: Int
    let height: Int
}

struct AnnotationSet: Codable {
    let fileName: String
    let annotatedImages: [AnnotatedImage]
}

struct AnnotatedImage : Codable {
    let name: String
    let label: String
    let x: Int
    let y: Int
    let width: Int
    let height: Int
}

extension AnnotatedImage {
    enum CodingKeys: String, CodingKey {
        case name
        case label
        case x
        case y
        case width
        case height
    }
}
