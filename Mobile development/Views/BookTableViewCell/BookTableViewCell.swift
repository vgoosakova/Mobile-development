//
//  BookTableViewCell.swift
//  Mobile development
//
//  Created by Viktory  on 14.03.2021.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setUp(book: Book) {
        bookImageView.image = book.bookImage
        titleLabel.text = book.title
        subTitleLabel.text = book.subtitle
        priceLabel.text = book.price
    }
    
}
