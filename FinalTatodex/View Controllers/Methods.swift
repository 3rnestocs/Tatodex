//
//  Methods.swift
//  FinalTatodex
//
//  Created by Ernesto Jose Contreras Lopez on 12/12/20.
//

import UIKit

//MARK: - TatodexController
extension TatodexController {
    
    //MARK: - - Main settings
    func configureViewStuff() {
        
        configureSearchBarButton()

        collectionViewPokemon?.register(TatodexCell.self,
                                forCellWithReuseIdentifier: reuseIdentifier)
        
        ///  This gestureRecognizer allows to dismiss the InfoView tapping outside
            let gesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(self.handleDismissal))
            self.visualEffectView.addGestureRecognizer(gesture)
    }
    
    //MARK: - - Conditionals
    func languageButtonConditionals() {
        if languageClickChecker {
            buttonChangeTheme?.setTitle("Activar tema azul", for: .normal)
            buttonChangeLanguage?.setTitle("Back to English", for: .normal)
        } else {
            buttonChangeTheme?.setTitle("Load blue theme", for: .normal)
            buttonChangeLanguage?.setTitle("Cambiar a español", for: .normal)
        }
    }

    func trueThemeCheckConditionals() {
        if themeClickCkecker && languageClickChecker {
            buttonChangeTheme?.setTitle("Regresar al tema clasico", for: .normal)
        } else {
            buttonChangeTheme?.setTitle("Return to classic theme", for: .normal)
        }
    }

    func falseThemeCheckConditionals() {
        if !themeClickCkecker && languageClickChecker {
            buttonChangeTheme?.setTitle("Activar tema azul", for: .normal)
        } else {
            buttonChangeTheme?.setTitle("Load blue theme", for: .normal)
        }
    }
    
    //MARK: - - SearchBar
    
    func configureSearchBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(searchTapped))
        navigationItem.rightBarButtonItem?.tintColor = Colors.mainGray
    }
    
    func searchBarConditionals() {
        
        if themeClickCkecker {
            searchBar.tintColor = Colors.darkBlue
        } else {
            searchBar.tintColor = Colors.darkRed
        }
        
        if languageClickChecker {
            searchBar.placeholder = "Busca a tu pokemon favorito"
        } else {
            searchBar.placeholder = "Search your favorite pokemon"
        }
        
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
    
    //MARK: - - Info stuff
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
    
    //MARK: - - API Call
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
    
    //MARK: - - Labels
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
    
    //MARK: - - Types parsing
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

//MARK: - InfoController
extension InfoController {
    
    //MARK: - - Labels
    func configuresLabel(label: UILabel, title: String, details: String) {
        
        var attributedText = NSMutableAttributedString()
        
        if themeClickCkecker {
            attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title):  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: Colors.darkBlue!]))
            
            shinyButton.backgroundColor = Colors.darkBlue
       } else {
           attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title):  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: Colors.darkRed!]))
        
        shinyButton.backgroundColor = Colors.darkRed
       }
        
        attributedText.append(NSAttributedString(string: "\(details)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        label.attributedText = attributedText
    }
    
    //MARK: -  - Skills parsing
    func getSkills(urls: [String]) {
        
        print("\(urls.count) skills registered. All working.")
        
        for url in urls {
            service.getTypesOrSkills(url: url) { [self] (skills) in
                
                for skill in skills {
                    
                    guard let skillName = skill.name else { return }
                    skillNameArray.append(skillName)
                    
                    /// COMENTARIO: Hay pokemones que tienen mas de 2 habilidades, debo crear el if-else que
                    /// maneje ese caso y actualice el skillLabel con cada una de las habilidades. Verificar si puedo
                    /// utilizar el compactMap con .joined(separatedBy: ", ") para registrarlos mas facil
                    
                    if languageClickChecker {
                        if skill.language?.name == "es" {
                            guard let skill1 = skillNameArray[5] as String? else { return }
                            if skillNameArray.count > 9 && skillNameArray.count < 21 {
                                guard let skill2 = skillNameArray[15] as String? else { return }
                                let mySkills = "\(skill1) y \(skill2)"
                                configuresLabel(label: infoView.skillLabel, title: "Habilidades", details: mySkills)
                            } else {
                                configuresLabel(label: infoView.skillLabel, title: "Habilidad", details: skill1)
                            }
                            if skillNameArray.count > 19 && skillNameArray.count < 31 {
                                    guard let skill2 = skillNameArray[15] as String?,
                                          let skill3 = skillNameArray[25] as String?
                                    else { return }
                                    let mySkills = "\(skill1), \(skill2) y \(skill3)"
                                    configuresLabel(label: infoView.skillLabel, title: "Habilidades", details: mySkills)
                            }
                            if skillNameArray.count > 29 && skillNameArray.count < 41 {
                                    guard let skill2 = skillNameArray[15] as String?,
                                          let skill3 = skillNameArray[25] as String?,
                                          let skill4 = skillNameArray[35] as String?
                                    else { return }
                                    let mySkills = "\(skill1), \(skill2), \(skill3) y \(skill4)"
                                    configuresLabel(label: infoView.skillLabel, title: "Habilidades", details: mySkills)
                            }
                        }
                    } else {
                        if skill.language?.name == "en" {
                            guard let skill1 = skillNameArray[7] as String? else { return }
                            if skillNameArray.count > 9 && skillNameArray.count < 21 {
                                guard let skill2 = skillNameArray[17] as String? else { return }

                                let mySkills = "\(skill1) and \(skill2)"
                                configuresLabel(label: infoView.skillLabel, title: "Skills", details: mySkills)
                            } else {
                                configuresLabel(label: infoView.skillLabel, title: "Skill", details: skill1)
                            }
                            if skillNameArray.count > 29 && skillNameArray.count < 41 {
                                guard let skill2 = skillNameArray[17] as String?,
                                      let skill3  = skillNameArray[27] as String?,
                                      let skill4 = skillNameArray[37] as String?
                                else { return }
                                let mySkills = "\(skill1), \(skill2), \(skill3) and \(skill4)"
                                configuresLabel(label: infoView.skillLabel, title: "Skills", details: mySkills)
                            }
                            if skillNameArray.count > 19 && skillNameArray.count < 31 {
                                guard let skill2 = skillNameArray[17] as String?,
                                      let skill3 = skillNameArray[27] as String?
                                else { return }
                                let mySkills = "\(skill1), \(skill2) and \(skill3)"
                                configuresLabel(label: infoView.skillLabel, title: "Skills", details: mySkills)
                            }
                        }
                    }
                }
            }
        }
    }
}
