//
//  ViewController.swift
//  Book.io
//
//  Created by fatih on 10/10/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var bookTableView: UITableView!
    @IBAction func addButtonOnClick(_ sender: Any) {
        //OPEN ADD BOOK VIEWCONTROLLER
        setupAddViewController()
        self.present(addViewController, animated: true, completion: nil)

    }
    //Private variables
    fileprivate var bookList = [BookModel]() //IMPLEMENT BOOK MODEL
    fileprivate var detailViewController : DetailViewController!
    fileprivate var addViewController : AddViewController!
    
}

//MARK: Override Methods
extension MainViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

//MARK: Setup Methods
extension MainViewController {
    func setupView(){
        setupTableView()
        setupDetailViewController()
    }
    func setupTableView(){
        bookTableView.delegate = self
        bookTableView.dataSource = self
        bookTableView.register(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: BookCell.reuseIdentifier)
        //MAKE API CALL AFTER CELL SETUP
        loadAllBooks()
    }
    func setupDetailViewController(){
        let detailMainStoryboard = UIStoryboard(name: "DetailViewController", bundle: nil)
        detailViewController = detailMainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
    }
    func setupAddViewController(){
        let addMainStoryboard = UIStoryboard(name: "AddViewController", bundle: nil)
        addViewController = addMainStoryboard.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController
    }
}

//MARK: Table View Delegate
extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookCell.cellHeight
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
}

//MARK: Table View Datasource
extension MainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
        //return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.reuseIdentifier, for: indexPath) as! BookCell
        cell.selectionStyle = .none
        if let currentModel = bookList[optional: indexPath.row] {
            cell.setWithBook(currentModel, atRow: indexPath.row)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentModel = bookList[safe: indexPath.row]{
            loadSingleBookDetail(book: currentModel)
        }
    }
}

//MARK: API Calls
extension MainViewController {
    @objc func loadAllBooks() {
        ApiManager.shared.getBookList { [weak self] (error, model) in
            DispatchQueue.main.async { [weak self] in
                if let error = error as? ServerError {
                    if !error.message.contains("JSON could not be") {
                        self?.present(AlertHelper.shared.alertErrorWith(title: nil,
                                                                        message: error.message,
                                                                        okAction: nil),
                                      animated: true,
                                      completion: nil)
                    }
                } else if let bookList = model as? [BookModel] {
                    self?.bookList = bookList
                    self?.bookTableView.reloadData()
                }
            }
        }
    }
    func loadSingleBookDetail(book: BookModel) {
        let detailVC = DetailViewController.instantiate(book: book)
        self.present(detailVC, animated: true, completion: nil)
    }
}
