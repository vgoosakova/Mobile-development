//
//  Lab3ViewController.swift
//  Mobile development
//
//  Created by Viktory  on 13.03.2021.
//

import UIKit

class Lab3ViewController: UIViewController {
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var books: [Book] = []
    var searchedBooks: [Book] = []
    var searchController: UISearchController!
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
        placeholderLabel.isHidden = true
        books = getBooks()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BookTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BookTableViewCell")
        tableView.reloadData()
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
    
    func getBooks() -> [Book] {
        
        do {
            if let path = Bundle.main.path(forResource: "BooksList", ofType: "txt"),
               let jsonData = try String(contentsOfFile: path, encoding: String.Encoding.utf8).data(using: .utf8) {
                
                let decodedData = try JSONDecoder().decode(Books.self, from: jsonData)
                return decodedData.books
            }
        } catch {
            print("Error: ", error.localizedDescription)
        }
        
        return []
    }
    
    func getBook(with id: String) -> Book? {
        
        guard !id.isEmpty else {
            return nil
        }
        
        do {
            if let path = Bundle.main.path(forResource: id, ofType: "txt"),
               let jsonData = try String(contentsOfFile: path, encoding: String.Encoding.utf8).data(using: .utf8) {
                
                let decodedData = try JSONDecoder().decode(Book.self, from: jsonData)
                return decodedData
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension Lab3ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchedBooks.count : books.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedBookID = isSearching ? searchedBooks[indexPath.row].isbn13 : books[indexPath.row].isbn13
        
        if let fullBook = getBook(with: selectedBookID) {
            
            let controller = Lab4ViewController.create(book: fullBook)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if isSearching {
                let bookToDelete = searchedBooks.remove(at: indexPath.row)
                books.removeAll { $0.isbn13 == bookToDelete.isbn13 }
            } else {
                books.remove(at: indexPath.row)
            }
            
            placeholderLabel.isHidden = !books.isEmpty
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }
        
        let book = isSearching ? searchedBooks[indexPath.row] : books[indexPath.row]
        cell.setUp(book: book)
        
        return cell
    }
}
extension Lab3ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let enteredText = searchController.searchBar.text?.lowercased(),
              !enteredText.isEmpty else {
            isSearching = false
            placeholderLabel.isHidden = !books.isEmpty
            tableView.reloadData()
            return
        }
        
        searchedBooks = books.filter { $0.title.lowercased().contains(enteredText) }
        placeholderLabel.isHidden = !searchedBooks.isEmpty
        isSearching = true
        tableView.reloadData()
    }
}

extension Lab3ViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isSearching = false
        placeholderLabel.isHidden = true
        tableView.reloadData()
    }
}
