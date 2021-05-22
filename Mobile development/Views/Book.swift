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
    let title, subtitle, isbn13, price, image: String
    let authors, publisher, pages, year, rating, desc: String?
    
    var bookPlaceholderImage: UIImage {
        
        return UIImage(systemName: "book")!
    }
}
