//
//  Lab5ViewController.swift
//  Mobile development
//
//  Created by Viktory  on 09.05.2021.
//

import UIKit

class Lab5ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var indicatorActivity: UIActivityIndicatorView!
    var pictures: [ModelImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        indicatorActivity.hidesWhenStopped = true
        indicatorActivity.layer.cornerRadius = 5
        getImages()
    }
    
    func getImages() {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pixabay.com"
        urlComponents.path = "/api"
        
        urlComponents.queryItems = [URLQueryItem(name: "key", value: "19193969-87191e5db266905fe8936d565"), URLQueryItem(name: "image_type", value: "photo"), URLQueryItem(name: "per_page", value: "21"), URLQueryItem(name: "q", value: "red+cars")]
        
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
                    let serverResponse = try JSONDecoder().decode(Images.self, from: data)
                    
                    DispatchQueue.main.async {
                        self?.indicatorActivity.stopAnimating()
                        self?.pictures = serverResponse.hits
                        self?.collectionView.reloadData()
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        .resume()
    }
    
    func setupCollectionView() {
        
        //let nib = UINib(nibName: "PicturesCollectionViewCell", bundle: .main)
        //collectionView.register(nib, forCellWithReuseIdentifier: "PicturesCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.register(PicturesCollectionViewCell.self, forCellWithReuseIdentifier: "PicturesCollectionViewCell")
        
        let layout = createLayout()
        
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let bigItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(1.0),
                                                   heightDimension: .fractionalWidth(3/5)))
            
            
            let littleItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(1/3)))
            
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/5),
                                                   heightDimension: .fractionalWidth(3/5)),
                subitem: littleItem, count: 3)
            
            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(3/5)),
                
                subitems: [verticalGroup, bigItem, verticalGroup])
            
            return NSCollectionLayoutSection(group: nestedGroup)
        }
        
        return layout
    }
    
}

extension Lab5ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicturesCollectionViewCell", for: indexPath) as! PicturesCollectionViewCell
        cell.pictureImageView.sd_setImage(with: URL(string: pictures[indexPath.row].webformatURL), placeholderImage: UIImage(systemName: "car.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal))
        return cell
    }
}
