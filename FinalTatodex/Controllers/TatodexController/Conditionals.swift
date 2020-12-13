//
//  Conditionals.swift
//  FinalTatodex
//
//  Created by Ernesto Jose Contreras Lopez on 12/13/20.
//

import Foundation

// MARK: - Abstractions

extension TatodexController {
    
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
}
