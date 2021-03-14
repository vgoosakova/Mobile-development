//
//  Book.swift
//  Mobile development
//
//  Created by Viktory  on 13.03.2021.
//

import UIKit

// MARK: - Books
struct Books: Codable {
    let books: [Book]
}

// MARK: - Book
struct Book: Codable {
    let title, subtitle, isbn13, price: String
    let image: String
    
    var bookImage: UIImage {
        guard !image.isEmpty else {
            return UIImage(systemName: "book")!
        }
        return UIImage(named: image) ?? UIImage(systemName: "book")!
    }
}
