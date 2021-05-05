//
//  Lab4ViewController.swift
//  Mobile development
//
//  Created by Viktory  on 05.05.2021.
//

import UIKit

class Lab4ViewController: UIViewController {
    
    static func create(book: Book) -> Lab4ViewController {
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main) .instantiateViewController(withIdentifier: "Lab4ViewController") as! Lab4ViewController
        controller.book = book
        return controller
    }
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleDescLabel: LabelWithDesc!
    @IBOutlet weak var subtitleDescLabel: LabelWithDesc!
    @IBOutlet weak var descLabel: LabelWithDesc!
    @IBOutlet weak var authorsLabel: LabelWithDesc!
    @IBOutlet weak var publisherLabel: LabelWithDesc!
    @IBOutlet weak var pagesLabel: LabelWithDesc!
    @IBOutlet weak var yearLabel: LabelWithDesc!
    @IBOutlet weak var ratingLabel: LabelWithDesc!
    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let book = book else {
            return
        }
        bookImageView.image = book.bookImage
        titleDescLabel.setup(with: book.title, description: "Title")
        subtitleDescLabel.setup(with: book.subtitle, description: "Subtitle")
        
        if let description = book.desc {
            descLabel.setup(with: description, description: "Description")
        } else {
            descLabel.isHidden = true
        }
        
        if let authors = book.authors {
            authorsLabel.setup(with: authors, description: "Authors")
        } else {
            authorsLabel.isHidden = true
        }

        if let publisher = book.publisher {
            publisherLabel.setup(with: publisher, description: "Publisher")
        } else {
            publisherLabel.isHidden = true
        }

        if let pages = book.pages {
            pagesLabel.setup(with: pages, description: "Pages")
        } else {
            pagesLabel.isHidden = true
        }

        if let year = book.year {
            yearLabel.setup(with: year, description: "Year")
        } else {
            yearLabel.isHidden = true
        }
        
        if let rating = book.rating {
            ratingLabel.setup(with: rating, description: "Rating")
        } else {
            ratingLabel.isHidden = true
        }
        
    }
    
}
