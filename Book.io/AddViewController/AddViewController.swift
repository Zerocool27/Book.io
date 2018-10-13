//
//  AddViewController.swift
//  Book.io
//
//  Created by fatih on 10/10/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import UIKit

class AddViewController: UIViewController{
    
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var categories: UITextField!
    @IBOutlet weak var publisher: UITextField!
    @IBOutlet weak var author: UITextField!
    @IBOutlet weak var bookTitle: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func doneButtonOnClick(_ sender: Any) {
        if !confirmPageClose(){
            self.dismiss(animated: true, completion: nil)
        }else{
            showConfirmPopup()
        }
    }
    @IBAction func submitButtonOnClick(_ sender: Any) {
        createNewBook()
    }
    
    
}

//MARK: Override Methods
extension AddViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

//MARK: Setup Methods
extension AddViewController {
    
    func setupView(){
        topContainer.addShadowWith(radius: 2, opacity: 0.1, offSet: CGSize(width: 0, height: 2))
        setupDoneButton()
        setupSubmitButton()
    }
    
    func setupDoneButton(){
        let greenColor =  UIColor(displayP3Red: 26/255, green: 188/255, blue: 156/255, alpha: 1) // Green Color
        doneButton.layer.cornerRadius = 8
        doneButton.layer.borderWidth = 2
        doneButton.layer.borderColor = greenColor.cgColor
        doneButton.setTitleColor(greenColor, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    func setupSubmitButton(){
        let greenColor =  UIColor(displayP3Red: 26/255, green: 188/255, blue: 156/255, alpha: 1) // Green Color
        submitButton.layer.cornerRadius = 10
        submitButton.layer.borderWidth = 2
        submitButton.layer.borderColor = greenColor.cgColor
        submitButton.setTitleColor(greenColor, for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    }
}

//MARK: Helper Methods
extension AddViewController{
    
    func confirmPageClose() -> Bool{
        if bookTitle.text?.isEmpty == false || author.text?.isEmpty == false || publisher.text?.isEmpty == false || categories.text?.isEmpty == false{
            return true
        }else{
            return false
        }
    }
    func showConfirmPopup(){
        let alert = UIAlertController(title: "You have unsaved changes!", message: "Do you really want to leave?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showInvalidFormPopup(){
        let alert = UIAlertController(title: "You have missing fields!", message: "Please fill the form properly", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: API Call & Validation
extension AddViewController{
    
    func isAuthorInValid() -> Bool{
        return author.text?.isEmpty ?? true
    }
    func isCategoriesInValid() -> Bool{
        return categories.text?.isEmpty ?? true
    }
    func isPublisherInValid() -> Bool{
        return publisher.text?.isEmpty ?? true
    }
    func isTitleInValid() -> Bool{
        return bookTitle.text?.isEmpty ?? true
    }
    
    func createNewBook(){
        
        if !isAuthorInValid() && !isCategoriesInValid() && !isPublisherInValid() && !isTitleInValid(){
            let authorStr = author.text!
            let categoryStr = categories.text!
            let publisherStr = publisher.text!
            let titleStr = bookTitle.text!
            ApiManager.shared.addBook(author:authorStr, categories:categoryStr, publisher: publisherStr, title: titleStr) { [unowned self] (error, model) in
                if let error = error as? ServerError {
                    DispatchQueue.main.async { [unowned self] () in
                        self.present(AlertHelper.shared.alertErrorWith(title: nil,
                                                                       message: error.message),
                                     animated: true,
                                     completion: nil)
                    }
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }else{
            //SHOW ALERT
            showInvalidFormPopup()
        }
    }
}
