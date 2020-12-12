//
//  Methods.swift
//  FinalTatodex
//
//  Created by Ernesto Jose Contreras Lopez on 12/12/20.
//

import UIKit

extension TatodexController {

    //MARK: - Setting views
    func configureViewStuff() {
        
        configureSearchBarButton()

        collectionViewPokemon?.register(TatodexCell.self,
                                forCellWithReuseIdentifier: reuseIdentifier)
        
        ///  This gestureRecognizer allows to dismiss the InfoView tapping outside
            let gesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(self.handleDismissal))
            self.visualEffectView.addGestureRecognizer(gesture)
    }
    
    //MARK: - SearchBar
    
    func configureSearchBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(searchTapped))
        navigationItem.rightBarButtonItem?.tintColor = Colors.mainGray
    }
    
    func configureSearchBar(showSearch: Bool) {
        
        ///  This disables the Search button when InfoView show's up. It turns on again when that view is dismissed.
        if showSearch {
            searchBar = UISearchBar()
            searchBar.showsCancelButton = true
            searchBar.backgroundColor   = Colors.mainGray
            searchBar.placeholder       = "Search your favorite pokemon"
            if clickCheck {
                searchBar.tintColor         = Colors.darkBlue
            } else {
                searchBar.tintColor         = Colors.darkRed
            }
            searchBar.delegate          = self
            searchBar.sizeToFit()
            searchBar.becomeFirstResponder()
            
            ///  This hides the search button when it's clicked, and the Search bar appears
            navigationItem.rightBarButtonItem   = nil
            navigationItem.titleView            = searchBar
        } else {
            navigationItem.titleView    = nil
            inSearchMode                = false
            configureSearchBarButton()
            collectionViewPokemon?.reloadData()
        }
    }
    
    //MARK: - InfoController
    func showInfoController(withPoke pokemon: Pokemon) {
        
        let controller      = InfoController()
        controller.pokemon  = pokemon
        self.navigationController?.pushViewController(controller,
                                                      animated: true)
    }

    //MARK: - InfoView
    func dismissInfoView(pokemon: Pokemon?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.infoView.alpha         = 0
            self.infoView.transform     = CGAffineTransform(scaleX: 1.3,
                                                            y: 1.3)
        }) { (_) in
            self.infoView.removeFromSuperview()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            guard let pokemon = pokemon else { return }
            self.showInfoController(withPoke: pokemon)
        }
    }
    
    //MARK: - API Call
    func fetchPokemons() {
        service.fetchPokes { (poke) in
            DispatchQueue.main.async {
                self.pokemons.append(poke)
                self.pokemons.sort { (poke1, poke2) -> Bool in
                    return poke1.name! < poke2.name!
                }
                self.collectionViewPokemon?.reloadData()
            }
        }
    }
}
