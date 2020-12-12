//
//  Delegates.swift
//  FinalTatodex
//
//  Created by Ernesto Jose Contreras Lopez on 12/12/20.
//

import UIKit

//MARK: SearchBar delegate
extension TatodexController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        ///  This checks if the user search something, and if it does, filters the pokemon
        ///  in the CollectionView by name
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            collectionViewPokemon?.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            filteredPokemon = pokemons.filter({ $0.name?.range(of: searchText.lowercased()) != nil })
            collectionViewPokemon?.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        configureSearchBar(showSearch: false)
    }
}

//MARK: - InfoViewlDelegate
extension TatodexController: TatodexCellDelegate {
    
    func presentInfoView(withPokemon pokemon: Pokemon) {
        
        ///  When the InfoView shows up, the search button goes off
        configureSearchBar(showSearch: false)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        ///  Setting up the InfoView disposure
        view.addSubview(infoView)
        infoView.configureViewComponents()
        infoView.delegate = self
        infoView.pokemon = pokemon
        infoView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 64, height: 480)
        infoView.layer.cornerRadius = view.frame.width / 6
        infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        
        infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        infoView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.visualEffectView.alpha = 1
            self.infoView.alpha = 1
            self.infoView.transform = .identity
        }
    }
}
