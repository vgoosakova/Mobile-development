//
//  Lab3ViewController.swift
//  Mobile development
//
//  Created by Viktory  on 13.03.2021.
//

import UIKit

class Lab3ViewController: UIViewController {
    
    @IBOutlet weak var indicatorActivity: UIActivityIndicatorView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var books: [Book] = []
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
        placeholderLabel.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BookTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BookTableViewCell")
        tableView.reloadData()
        indicatorActivity.hidesWhenStopped = true
        indicatorActivity.layer.cornerRadius = 5
    }
    
    func getBooks(with name: String) {
        
        guard name.count >= 3 else {
            books = []
            placeholderLabel.isHidden = false
            tableView.reloadData()
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.itbook.store"
        urlComponents.path = "/1.0/search/\(name)"
        
        guard let url = urlComponents.url else {
            return
        }
        
        indicatorActivity.startAnimating()
        
        URLSession(configuration: .default).dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let serverResponse = try JSONDecoder().decode(Books.self, from: data)
                    
                    DispatchQueue.main.async {
                        self?.indicatorActivity.stopAnimating()
                        self?.books = serverResponse.books
                        self?.placeholderLabel.isHidden = !serverResponse.books.isEmpty
                        self?.tableView.reloadData()
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        .resume()
    }
    
    func getFullBook(with id: String) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.itbook.store"
        urlComponents.path = "/1.0/books/\(id)"
        
        guard let url = urlComponents.url else {
            return
        }
        
        indicatorActivity.startAnimating()
        
        URLSession(configuration: .default).dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let serverResponse = try JSONDecoder().decode(Book.self, from: data)
                    
                    DispatchQueue.main.async {
                        self?.indicatorActivity.stopAnimating()
                        let controller = Lab4ViewController.create(book: serverResponse)
                        self?.navigationController?.pushViewController(controller, animated: true)
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        .resume()
    }
    
    @IBAction func addAction(_ sender: Any) {
        
        let createBookAlert = UIAlertController(title: "Add new book", message: "You cant add book.", preferredStyle: .alert)
        
        createBookAlert.addTextField { $0.placeholder = "Book title" }
        createBookAlert.addTextField { $0.placeholder = "Book subtitle" }
        createBookAlert.addTextField {
            $0.keyboardType = .numberPad
            $0.placeholder = "Book price"
        }
        
        createBookAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        createBookAlert.addAction(UIAlertAction(title: "Add", style: .default) { [weak createBookAlert, weak self] _ in
            
            guard let title = createBookAlert?.textFields?[0].text,
                  let subTitle = createBookAlert?.textFields?[1].text,
                  let price = createBookAlert?.textFields?[2].text else {
                return
            }
            
            guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  !subTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  !price.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                
                let alert = UIAlertController(title: "Enter all parameters", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(alert, animated: true)
                return
            }
            
            guard let intPrice = Int(price),
                  intPrice > 0 else {
                
                let alert = UIAlertController(title: "Invalid price", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(alert, animated: true)
                return
            }
            
            self?.createBook(title: title, subtitle: subTitle, price: "$\(price)")
        })
        
        present(createBookAlert, animated: true)
    }
    
    private func createBook(title: String, subtitle: String, price: String) {
        
        let newBook = Book(title: title, subtitle: subtitle, isbn13: UUID().uuidString, price: price, image: "", authors: nil, publisher: nil, pages: nil, year: nil, rating: nil, desc: nil)
        
        books.append(newBook)
        tableView.reloadData()
        placeholderLabel.isHidden = !books.isEmpty
    }
    
    private func setupSearch() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
}

extension Lab3ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let selectedBookID = books[indexPath.row].isbn13
        
        getFullBook(with: selectedBookID)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }
        
        let book = books[indexPath.row]
        cell.setUp(book: book)
        
        return cell
    }
}
extension Lab3ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let enteredText = searchController.searchBar.text?.lowercased(),
              !enteredText.isEmpty else {
            placeholderLabel.isHidden = !books.isEmpty
            tableView.reloadData()
            return
        }
        
        getBooks(with: enteredText)
    }
}

extension Lab3ViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        books = []
        placeholderLabel.isHidden = false
        tableView.reloadData()
    }
}
