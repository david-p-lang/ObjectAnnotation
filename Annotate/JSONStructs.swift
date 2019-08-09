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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        
    }
}

struct AnnotationSet: Codable {
    let fileName: String
    let annotatedImages: [AnnotatedImage]
}

struct AnnotatedImage : Codable {
    let name: String
    let label: String
    let x: Int
    //let y: Int

    let width: Int
    let height: Int
    
    init(name: String, label: String, x: Int, y: Int, width: Int, height: Int) {
        self.name = name
        self.label = label
        self.x = x
        //self.y = y
        self.width = width
        self.height = height
    }
}

extension AnnotatedImage {
    enum CodingKeys: CodingKey {
        case name
        case label
        case x
        //case y

        case width
        case height
    }
    

    
}
