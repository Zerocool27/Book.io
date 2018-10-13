//
//  DetailViewController.swift
//  Book.io
//
//  Created by fatih on 10/10/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import UIKit

//MARK: IBs and Private Variables
class DetailViewController: UIViewController{
    
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var lastCheckedOut: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    @IBAction func backButtonOnClick(_ sender: Any) {
        //POP CURRENT VIEW
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func shareButtonOnClick(_ sender: Any) {
        showBuiltInShareView()
    }
    
    @IBAction func checkoutOnClick(_ sender: Any) {
        showNameEntryPopup()
    }
    var currentBook: BookModel!
}

//MARK: Override Methods
extension DetailViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

//MARK: Setup Methods
extension DetailViewController {
    
    func setupView(){
        topContainer.addShadowWith(radius: 2, opacity: 0.1, offSet: CGSize(width: 0, height: 2))
        setupCheckoutButton()
        loadBookDetail()
    }
    func setupCheckoutButton(){
        let greenColor =  UIColor(displayP3Red: 26/255, green: 188/255, blue: 156/255, alpha: 1) // Green Color
        checkoutButton.layer.cornerRadius = 10
        checkoutButton.layer.borderWidth = 2
        checkoutButton.layer.borderColor = greenColor.cgColor
        checkoutButton.setTitleColor(greenColor, for: .normal)
        checkoutButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    }
}

//MARK: Custom Init Method
extension DetailViewController {
    
    static func instantiate(book: BookModel) -> DetailViewController {
        let detailMainStoryboard = UIStoryboard(name: "DetailViewController", bundle: nil)
        let vc = detailMainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.currentBook = book
//
        return vc
    }
}
//MARK: Helper Methods
extension DetailViewController {
    
    func showNameEntryPopup(){
        let alert = UIAlertController(title: "Please enter your name", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            //IMPLEMENT AFTER NAME ENTER
            let textField = alert!.textFields![0]
            //IMPLEMENT API CALL
            if textField.text?.isEmpty == false{
                self.updateBookDetail(withName: textField.text!)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showBuiltInShareView(){
        
        let message = "BOOK DETAILS\n" +
            "Book Title: " + "\(currentBook.title)\n" +
            "Book Author: " + "\(currentBook.author)\n" +
            "Book Publisher: " + "\(currentBook.publisher)\n" +
            "Book Categories: " + "\(currentBook.categories)\n"
        let activityViewController = UIActivityViewController(activityItems: [message as NSString], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let wPPC = activityViewController.popoverPresentationController {
                wPPC.sourceView = self.view
            }
        }
        self.present(activityViewController, animated: true, completion: {})
    }
}
//MARK: API Calls
extension DetailViewController{
    
    func loadBookDetail(){
        if let book = currentBook{
            ApiManager.shared.getBook(bookId:book.id,  completion: { (error, model) in
                DispatchQueue.main.async { [weak self] in
                    if let error = error as? ServerError {
                        if !error.message.contains("JSON could not be") {
                            self?.present(AlertHelper.shared.alertErrorWith(title: nil,
                                                                            message: error.message,
                                                                            okAction: nil),
                                          animated: true,
                                          completion: nil)
                        }
                    } else if let book = model as? BookModel {
                        self?.bookTitle.text = book.title
                        self?.bookAuthor.text = book.author
                        self?.publisher.text = book.publisher
                        self?.tags.text = book.categories
                        self?.lastCheckedOut.text = book.getFormattedCheckoutString()
                    }
                }
            })
        }
    }
    func updateBookDetail(withName: String){
        if let book = currentBook{
            ApiManager.shared.updateBook(bookId:book.id,lastCheckedOutBy: withName) { (error, model) in
                DispatchQueue.main.async { [weak self] in
                    if let error = error as? ServerError {
                        if !error.message.contains("JSON could not be") {
                            self?.present(AlertHelper.shared.alertErrorWith(title: nil,
                                                                            message: error.message,
                                                                            okAction: nil),
                                          animated: true,
                                          completion: nil)
                        }
                    } else if let book = model as? BookModel {
                        self?.bookTitle.text = book.title
                        self?.bookAuthor.text = book.author
                        self?.publisher.text = book.publisher
                        self?.tags.text = book.categories
                        self?.lastCheckedOut.text = book.getFormattedCheckoutString()
                    }
                }
            }
        }
    }
}
