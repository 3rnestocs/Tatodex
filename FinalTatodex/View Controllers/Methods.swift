//
//  Methods.swift
//  FinalTatodex
//
//  Created by Ernesto Jose Contreras Lopez on 12/12/20.
//

import UIKit

extension TatodexController {

    //MARK: - Main settings
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
            searchBar.delegate          = self
            searchBar.sizeToFit()
            searchBar.becomeFirstResponder()
            searchBarConditionals()
            
            ///  This hides the search button when it's clicked, and the Search bar appears
            navigationItem.rightBarButtonItem = nil
            navigationItem.titleView          = searchBar
        } else {
            navigationItem.titleView = nil
            inSearchMode             = false
            configureSearchBarButton()
            collectionViewPokemon?.reloadData()
        }
    }
    
    //MARK: - Info stuff
    func showInfoController(withPoke pokemon: Pokemon) {
        
        let controller      = InfoController()
        controller.pokemon  = pokemon
        self.navigationController?.pushViewController(controller,
                                                      animated: true)
    }

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

// MARK: - InfoView
extension InfoView {
    
    func configureLabel(label: UILabel, title: String, details: String) {
        
        var attributedText = NSMutableAttributedString()
        
        if languageClickChecker {
            infoButton.setTitle("Ver mas informacion", for: .normal)
        } else {
            infoButton.setTitle("View More Info", for: .normal)
        }
        
        if themeClickCkecker {
             attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title):  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: Colors.darkBlue!]))
        } else {
            attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title):  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: Colors.darkRed!]))
        }
        
        attributedText.append(NSAttributedString(string: "\(details)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        label.attributedText = attributedText
    }
    
    func getMytypes(typeUrl: [String]) {
        
        print("\(typeUrl.count) types registered. All working.")
        
        for url in typeUrl {
            service.getTypesOrSkills(url: url) { [self] (names) in
                
                for name in names {
                    
                    guard let types = name.name else { return }
                    typeNameArray.append(types)
                    
                    if languageClickChecker {
                        if name.language?.name == "es" {
                            guard let firstType = typeNameArray[4] as String? else { return }
                            if typeNameArray.count > 6 {
                                guard let secondType = typeNameArray[11] as String? else { return }

                                let myTypes     = "\(firstType) y \(secondType)"
                                configureLabel(label: typeLabel,  title: "Tipos", details: myTypes)
                            } else {
                                configureLabel(label: typeLabel, title: "Tipo", details: firstType)
                            }
                        }
                    } else {
                        if name.language?.name == "en" {
                            
                            guard let firstType = typeNameArray[6] as String? else { return }
                            if typeNameArray.count > 6 {
                                guard let secondType = typeNameArray.last else { return }
                                if firstType == secondType {
                                    configureLabel(label: typeLabel, title: "Type", details: firstType)
                                } else {
                                    let myTypes     = "\(firstType) and \(secondType)"
                                    configureLabel(label: typeLabel,  title: "Types", details: myTypes)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
