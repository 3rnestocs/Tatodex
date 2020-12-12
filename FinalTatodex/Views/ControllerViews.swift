//
//  FirstViews.swift
//  FinalTatodex
//
//  Created by Ernesto Jose Contreras Lopez on 12/10/20.
//

import UIKit

extension TatodexController {
    func setViews() {
        
        /// Create the mainView and add it to the controller safely
        guard let viewBigScreen = viewBigScreen else { return }
        view.addSubview(viewBigScreen)
        
        /// Create the theme switcher button and add it to the viewBigScreen safely
        guard let buttonChangeTheme = buttonChangeTheme else { return }
        viewBigScreen.addSubview(buttonChangeTheme)
        
        /// Create the language switcher button and add it to the viewBigScreen safely
        guard let buttonChangeLanguage = buttonChangeLanguage else { return }
        viewBigScreen.addSubview(buttonChangeLanguage)
        
        /// Create the CollectionView and add it inside the viewBigScreen safely
        guard let collectionViewPokemon  = collectionViewPokemon else { return }
        viewBigScreen.addSubview(collectionViewPokemon)

        viewBigScreen.anchor(top: view.topAnchor, paddingTop: 0, bottom: view.bottomAnchor,
                             paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0,
                             right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        viewBigScreen.addSubview(visualEffectView)
        visualEffectView.anchor(top: viewBigScreen.topAnchor, left: viewBigScreen.leftAnchor,
                                bottom: viewBigScreen.bottomAnchor, right: viewBigScreen.rightAnchor,
                                paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                                width: 0, height: 0)
        visualEffectView.alpha = 0
        
        buttonChangeTheme.anchor(top: viewBigScreen.topAnchor, left: viewBigScreen.leftAnchor,
                                 bottom: collectionViewPokemon.topAnchor, right: viewBigScreen.rightAnchor,
                                 paddingTop: 30, paddingLeft: 0, paddingBottom: 30,
                                 paddingRight: view.frame.width/2, width: 0, height: 70)
        
        buttonChangeLanguage.anchor(top: viewBigScreen.topAnchor, left: viewBigScreen.leftAnchor,
                                 bottom: collectionViewPokemon.topAnchor, right: viewBigScreen.rightAnchor,
                                 paddingTop: 30, paddingLeft: view.frame.width/2, paddingBottom: 30,
                                 paddingRight: 0, width: 0, height: buttonChangeTheme.frame.height)

        collectionViewPokemon.frame      = viewBigScreen.bounds
        collectionViewPokemon.dataSource = self
        collectionViewPokemon.delegate   = self
        
        navigationItem.title                                = "Tatodex"
        collectionViewPokemon.backgroundColor               = Colors.darkRed
        navigationController?.navigationBar.barTintColor    = Colors.lightRed
        navigationController?.navigationBar.barStyle        = .black
        navigationController?.navigationBar.isTranslucent   = false
        
        collectionViewPokemon.anchor(top: nil, paddingTop: 0, bottom: viewBigScreen.bottomAnchor,
                                     paddingBottom: 0, left: viewBigScreen.leftAnchor,
                                     paddingLeft: 0, right: viewBigScreen.rightAnchor,
                                     paddingRight: 0, width: 0, height: view.frame.height/1.5)
    }
}

extension InfoController {
    
    func configureViewComponents() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(imageView)
        view.addSubview(shinyButton)
                
        ///  Set up for small devices (Height < 700pts)
        if view.frame.height <= 700 {
            imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
            
            shinyButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
            
            infoLabel.font = UIFont.systemFont(ofSize: 15)
            
        } else {
            imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)

            shinyButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 80, paddingRight: 0, width: 0, height: 50)

            infoLabel.font = UIFont.systemFont(ofSize: 17)
        }
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        infoLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        view.addSubview(infoView)
        infoView.anchor(top: infoLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
