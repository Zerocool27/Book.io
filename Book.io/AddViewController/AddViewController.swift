//
//  AddViewController.swift
//  Book.io
//
//  Created by fatih on 10/10/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import UIKit

class AddViewController: UIViewController{
    
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
}
