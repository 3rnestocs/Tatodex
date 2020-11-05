//
//  TatodexController.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/4/20.
//

import UIKit

//  This is a reusable cell identifier to minimize human error while using it
private let reuseIdentifier = "TatodexCell"

class TatodexController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewStuff()
    }
}

extension TatodexController {

    //MARK: - View settings
    func configureViewStuff() {
        
        collectionView.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = Colors.softRed
        navigationController?.navigationBar.barStyle     = .black
        
        navigationItem.title = "Tatodex"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        collectionView.register(TatodexCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    @objc func searchTapped() {
        print("1 2 3")
    }

    //MARK: - View disposure
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 32
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TatodexCell
        
        cell.backgroundColor = Colors.softRed
        
        return cell
    }
}

extension TatodexController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 8, bottom: 32, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 3
        return CGSize(width: width, height: width)
    }
}


