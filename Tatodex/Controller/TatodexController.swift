//
//  TatodexController.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/4/20.
//

import UIKit

//private let reuseIdentifier = "Cell"

class TatodexController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewStuff()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
}

extension TatodexController {
    
    @objc func searchTapped() {
        print("1 2 3")
    }
    
    func configureViewStuff() {
        
        collectionView.backgroundColor = Colors.myWhite
        
        navigationController?.navigationBar.barTintColor = Colors.mainOrange
        navigationController?.navigationBar.barStyle     = .black
        
        navigationItem.title = "Tatodex"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
    }
    
}

