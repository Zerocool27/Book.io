//
//  TableViewCell.swift
//  Book.io
//
//  Created by fatih on 10/10/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import UIKit
protocol BookCellDelegate {
    func bookcell(_ bookCell : BookCell, deleteBookById: Int)
}
class BookCell: UITableViewCell {
    
    static let reuseIdentifier = "BookCell"
    static let cellHeight: CGFloat = 80
    var delegate: BookCellDelegate?

    @IBAction func deleteOnClick(_ sender: Any) {
        delegate?.bookcell(self, deleteBookById: id)
    }
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    var categories = ""
    var id = 0
    var lastCheckedOut = ""
    var lastCheckedOutBy = ""
    var publisher = ""
    var updatedAt = ""
    var createdAt = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Open methods
extension BookCell {
    
    func setWithBook(_ model: BookModel, atRow row: Int) {
        bookTitle.text = model.title
        bookAuthor.text = model.author
        categories = model.categories
        id = model.id
        lastCheckedOut = model.lastCheckedOut
        lastCheckedOutBy = model.lastCheckedOutBy
        publisher = model.publisher
        updatedAt = model.updatedAt
        createdAt = model.createdAt
    }
    
}
