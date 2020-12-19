//
//  Selectors.swift
//  FinalTatodex
//
//  Created by Ernesto Jose Contreras Lopez on 12/12/20.
//

import UIKit

extension TatodexController {
    
    //MARK: - Search button
    @objc func searchButtonClicked() {
        configureSearchBar(showSearch: true)
    }

    //MARK: - InfoView dismisser
    @objc func handleDismissal() {
        dismissInfoView(pokemon: nil)
    }

    //MARK: - Buttons
    @objc func refreshButtonClicked() {
        
        if pokemons.count != 0 {
            collectionViewPokemon?.isHidden = false
            emptyView?.isHidden = true
            refreshButton?.isHidden = true
        }

        print("Refreshed")
    }
    
    @objc func handleMenuToggle() {
            print("Menu activated")
    }
    
    @objc func langButtonClicked() {
        
        languageClickChecker = !languageClickChecker
        configureLanguageConditionals()
    }
    
    @objc func themeButtonClicked() {
        
        themeClickCkecker = !themeClickCkecker
        
        if themeClickCkecker {
            navigationController?.navigationBar.barTintColor = Colors.lightBlue
            infoController.shinyButton.backgroundColor       = Colors.lightBlue
            
            infoView.nameContainerView.backgroundColor = Colors.lightBlue
            infoView.infoButton.backgroundColor        = Colors.lightBlue
            
            collectionViewPokemon?.backgroundColor = Colors.darkBlue
            buttonChangeLanguage?.backgroundColor  = Colors.darkBlue
            
            buttonChangeTheme?.backgroundColor = Colors.darkRed
            configureTrueThemeConditionals()
            
        } else {
            navigationController?.navigationBar.barTintColor = Colors.lightRed
            infoController.shinyButton.backgroundColor       = Colors.lightRed
            
            infoView.nameContainerView.backgroundColor = Colors.lightRed
            infoView.infoButton.backgroundColor        = Colors.lightRed
            
            collectionViewPokemon?.backgroundColor = Colors.darkRed
            buttonChangeLanguage?.backgroundColor  = Colors.darkRed
            
            buttonChangeTheme?.backgroundColor = Colors.darkBlue
            configureFalseThemeConditionals()
        }
        collectionViewPokemon?.reloadData()
    }
}

extension TatodexCell {
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            guard let pokemon = self.pokemon else { return }
            delegate?.presentInfoView(withPokemon: pokemon)
        }
    }
    
}
