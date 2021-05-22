//
//  Lab5ViewController.swift
//  Mobile development
//
//  Created by Viktory  on 09.05.2021.
//

import UIKit

class Lab5ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imagePicker: ImagePicker!
    var pictures: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
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
    
    @IBAction func showImagePicker(_ sender: Any) {
        self.imagePicker.present()
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

extension Lab5ViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if let image = image {
            pictures.append(image)
            collectionView.reloadData()
        }
    }
}

extension Lab5ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicturesCollectionViewCell", for: indexPath) as! PicturesCollectionViewCell
        cell.pictureImageView.image = pictures[indexPath.row]
        return cell
    }
}
