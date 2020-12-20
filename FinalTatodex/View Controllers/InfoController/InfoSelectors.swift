//
//  InfoSelectors.swift
//  FinalTatodex
//
//  Created by Ernesto Jose Contreras Lopez on 12/17/20.
//

import Foundation

extension InfoController {
    
    @objc func shinyButtonClicked() {
        
        shinyClickChecker = !shinyClickChecker
        imageView.kf.indicatorType = .activity
        
        guard let shiny         = self.pokemon?.sprites?.shiny,
              let frontSprite   = self.pokemon?.sprites?.front
        else { return }

        if shinyClickChecker {
            imageView.kf.setImage(with: URL(string: shiny))
            
            if languageClickChecker {
                shinyButton.setTitle("Vuelve a ver al original!",
                                     for: .normal)
            } else {
                shinyButton.setTitle("Return to it's normal version!",
                                     for: .normal)
            }
        } else {
            imageView.kf.setImage(with: URL(string: frontSprite))
            
            if languageClickChecker {
                shinyButton.setTitle("Mira la version shiny!",
                                     for: .normal)
            } else {
                shinyButton.setTitle("See it's shiny version!",
                                     for: .normal)
            }
        }
    }
    
}
