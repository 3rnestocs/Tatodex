//
//  Selectors.swift
//  FinalTatodex
//
//  Created by Ernesto Jose Contreras Lopez on 12/12/20.
//

import UIKit

extension TatodexController {
    
    //MARK: - Search button
    @objc func searchTapped() {
        configureSearchBar(showSearch: true)
    }

    //MARK: - InfoView dismisser
    @objc func handleDismissal() {
        dismissInfoView(pokemon: nil)
    }

    //MARK: - Theme button
    @objc func themeButtonClicked() {
        
        clickCheck = !clickCheck
        
        guard let searchbar = searchBar else { return }
        
        if clickCheck {
            navigationController?.navigationBar.barTintColor = Colors.lightBlue
            infoController.shinyButton.backgroundColor       = Colors.lightBlue
            
            infoView.nameContainerView.backgroundColor = Colors.lightBlue
            infoView.infoButton.backgroundColor        = Colors.lightBlue
            
            collectionViewPokemon?.backgroundColor = Colors.darkBlue
            buttonChangeLanguage?.backgroundColor  = Colors.darkBlue
            
            buttonChangeTheme?.backgroundColor     = Colors.darkRed
            buttonChangeTheme?.setTitle("Return to red theme", for: .normal)
        } else {
            navigationController?.navigationBar.barTintColor = Colors.lightRed
            infoController.shinyButton.backgroundColor       = Colors.lightRed
            
            infoView.nameContainerView.backgroundColor = Colors.lightRed
            infoView.infoButton.backgroundColor        = Colors.lightRed
            
            collectionViewPokemon?.backgroundColor = Colors.darkRed
            buttonChangeLanguage?.backgroundColor  = Colors.darkRed
            
            buttonChangeTheme?.backgroundColor     = Colors.darkBlue
            buttonChangeTheme?.setTitle("Change to blue theme", for: .normal)
        }
        collectionViewPokemon?.reloadData()
    }
}
