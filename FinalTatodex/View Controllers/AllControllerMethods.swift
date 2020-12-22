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

        configureNavigationBarButtons()
        
        ///  This gestureRecognizer allows to dismiss the InfoView tapping outside
            let gesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(self.handleDismissal))
            self.visualEffectView.addGestureRecognizer(gesture)
    }
    
    //MARK: - - Conditionals
    func configureLanguageConditionals() {
        
        if languageClickChecker {
            buttonChangeTheme?.setTitle("Activar tema azul", for: .normal)
            buttonChangeLanguage?.setTitle("Back to English", for: .normal)
        } else {
            buttonChangeTheme?.setTitle("Load blue theme", for: .normal)
            buttonChangeLanguage?.setTitle("Cambiar a español", for: .normal)
        }
    }

    func configureTrueThemeConditionals() {
        if themeClickCkecker && languageClickChecker {
            buttonChangeTheme?.setTitle("Regresar al tema clasico", for: .normal)
        } else {
            buttonChangeTheme?.setTitle("Return to classic theme", for: .normal)
        }
    }

    func configureFalseThemeConditionals() {
        if !themeClickCkecker && languageClickChecker {
            buttonChangeTheme?.setTitle("Activar tema azul", for: .normal)
        } else {
            buttonChangeTheme?.setTitle("Load blue theme", for: .normal)
        }
    }
    
    //MARK: -  NavBar Buttons
    
    func configureNavigationBarButtons() {
        
        /// NavigationBar configuration
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle      = .black
        navigationItem.title                              = "Tatodex"
        
        configureSearchBarButtons()
        setUpMenuButton()
    }
    
    func setUpMenuButton(){
        let menuBtn = UIButton(type: .system)
        menuBtn.setImage(UIImage(named:"menuicon"), for: .normal)
        menuBtn.addTarget(self, action: #selector(handleMenuToggle), for: .touchUpInside)
        menuBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
        menuBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBtn.tintColor = Colors.mainGray
        
        let menu = UIBarButtonItem(customView: menuBtn)
        navigationItem.setLeftBarButton(menu, animated: true)
    }
    
    func configureSearchBarButtons() {

        let searchBtn = UIButton(type: .system)
        searchBtn.setImage(UIImage(named:"search"), for: .normal)
        searchBtn.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        searchBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
        searchBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
        searchBtn.tintColor = Colors.mainGray
        
        let search = UIBarButtonItem(customView: searchBtn)
        navigationItem.setRightBarButton(search, animated: true)
        }
    
    func configureNavBarConditionals() {
        
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
            navigationItem.leftBarButtonItem = nil
            searchBar.sizeToFit()
            searchBar.becomeFirstResponder()
            configureNavBarConditionals()
            
            ///  This hides the search button when it's clicked, and the Search bar appears
            navigationItem.rightBarButtonItem = nil
            navigationItem.titleView          = searchBar
        } else {
            navigationItem.titleView = nil
            inSearchMode             = false
            configureNavigationBarButtons()
            setUpMenuButton()
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
        
        print("---FIRST API CALL---")
        service.fetchFirstPokes(pagination: false) { [self] (result) in
            switch result {
            case .success(let pokes):

                pokemons = pokes
                DispatchQueue.main.async {
                    collectionViewPokemon?.reloadData()
                }
            case .failure(let error):
                print("DEBUG \(NetworkResponse.failed): \(error)" )
                emptyViewController.getEmptyView()
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
    func configureTypes(typeUrl: [String]) {
        
        print("\(typeUrl.count) types registered. All working.")
        
        for url in typeUrl {
            service.getTypesOrSkills(url: url) { [self] (result) in
                
                switch result {
                case .success(let names):
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
                case .failure(let error):
                    print("DEBUG \(NetworkResponse.failed): \(error)" )
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
    func configureSkills(urls: [String]) {
        
        print("\(urls.count) skills registered. All working.")
        
        for url in urls {
            service.getTypesOrSkills(url: url) { [self] (result) in
                
                switch result {
                case .success(let skills):
                for skill in skills {
                    
                    guard let skillName = skill.name else { return }
                    skillNameArray.append(skillName)
                    
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
                case .failure(let error):
                    print("DEBUG \(NetworkResponse.failed): \(error)" )
                }
            }
        }
    }
}

extension EmptyViewController {
    
    func configureEmptyViews() {
        
        if languageClickChecker {
            emptyLabel.text      = "Lo sentimos, no pudimos obtener la informacion correctamente. Por favor, reinicia la aplicacion."
            tatodexController.refreshButton?.setTitle("Intentar de nuevo", for: .normal)
        } else {
            emptyLabel.text      = "We're sorry, couldn't get the data correctly. Please reload the app."
            tatodexController.refreshButton?.setTitle("Try again", for: .normal)
        }
        
    }
    
    func getEmptyView() {
        
        configureEmptyViews()
        
        if tatodexController.pokemons.count == 0 {
            guard let emptyView = emptyView else { return }
            tatodexController.viewBigScreen!.addSubview(emptyView)
            
            emptyView.anchor(top: nil, paddingTop: 0, bottom: tatodexController.viewBigScreen!.bottomAnchor,
                             paddingBottom: 0, left: tatodexController.viewBigScreen!.leftAnchor,
                             paddingLeft: 0, right: tatodexController.viewBigScreen!.rightAnchor,
                             paddingRight: 0, width: 0, height: tatodexController.view.frame.height/1.2)
            
            guard let refreshButton = tatodexController.refreshButton else { return }
            tatodexController.viewBigScreen!.addSubview(refreshButton)
            refreshButton.anchor(top: nil, paddingTop: 0, bottom: tatodexController.view.bottomAnchor, paddingBottom: 100, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 200, height: 0)
            refreshButton.centerXAnchor.constraint(equalTo: tatodexController.view.centerXAnchor).isActive = true
            refreshButton.layer.cornerRadius = 10
            
            tatodexController.collectionViewPokemon?.isHidden = true
        }
    }
    
}
