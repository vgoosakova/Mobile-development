//
//  ModelImage.swift
//  Mobile development
//
//  Created by Viktory  on 22.05.2021.
//

import Foundation

struct ModelImage: Codable {
    var id: Int
    var webformatURL: String
}

struct Images: Codable {
    var hits: [ModelImage]
}
