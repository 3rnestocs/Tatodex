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
    
    //MARK: - Properties
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var searchBar: UISearchBar!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewStuff()
        fetchPokemons()
    }
    
    //MARK: - Selectors
    @objc func searchTapped() {
        configureSearchBar()
    }
}

extension TatodexController {

    //MARK: - Helper functions
    func configureViewStuff() {
        
        collectionView.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = Colors.softRed
        navigationController?.navigationBar.barStyle     = .black
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "Tatodex"
        
        configureSearchBarButton()

        collectionView.register(TatodexCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.tintColor = .white
        searchBar.placeholder = "Search your favorite pokemon"
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
    }
    
    func configureSearchBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        navigationItem.rightBarButtonItem?.tintColor = Colors.myWhite
    }
}
    
extension TatodexController {
        
    //MARK: - CollectionView DataSource/Delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPokemon.count : pokemon.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TatodexCell
        
        cell.pokemon = inSearchMode ? filteredPokemon[indexPath.row] : pokemon[indexPath.row]
        
        return cell
    }
}

extension TatodexController: UISearchBarDelegate {
    
    //MARK: UISearchBar delegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        configureSearchBarButton()
        inSearchMode = false
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            filteredPokemon = pokemon.filter({ $0.name?.range(of: searchText.lowercased()) != nil })
            collectionView.reloadData()
        }
    }
}

//MARK: - View disposure
extension TatodexController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 12, bottom: 32, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 2
        return CGSize(width: width, height: width)
    }
}


