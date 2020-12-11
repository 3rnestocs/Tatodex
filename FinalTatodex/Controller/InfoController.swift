//
//  InfoController.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/8/20.
//

import UIKit
import Alamofire

var controller      = TatodexController()
var infoController  = InfoController()

class InfoController: UIViewController {
    
    // MARK: - Properties

    var pressedButton   = true
    var pokemon: Pokemon? {
        didSet {
            guard let pokemon  = pokemon,
                  let sprites  = pokemon.sprites?.front,
                  let stats    = pokemon.stats,
                  let names    = pokemon.abilities?.compactMap({ $0.ability?.name?.capitalized }).joined(separator: ", ")
            else { return }
            
            let statNum = stats.compactMap { $0.baseStat }
            
            navigationItem.title    = pokemon.name?.capitalized
            infoView.pokemon        = pokemon
            DispatchQueue.main.async {
                self.imageView.kf.setImage(with: URL(string: sprites))
            }
            
            self.infoView.configureLabel(label: self.infoView.skillLabel,
                                         title: "Skills",           details: names)
            self.infoView.configureLabel(label: self.infoView.hpLabel,
                                         title: "HP",               details: "\(statNum[0])")
            self.infoView.configureLabel(label: self.infoView.speedLabel,
                                         title: "Speed",            details: "\(statNum[5])")
            self.infoView.configureLabel(label: self.infoView.specialAttackLabel,
                                         title: "Special-Attack",   details: "\(statNum[3])")
            self.infoView.configureLabel(label: self.infoView.specialDefenseLabel,
                                         title: "Special-Defense",  details: "\(statNum[4])")
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    let infoView: InfoView = {
        let view = InfoView()
        view.configureViewForInfoController()
        return view
    }()
    
    var shinyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor  = Colors.lightRed
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25,
                                                    weight: .semibold)
        button.tintColor        = Colors.mainWhite
        button.addTarget(self,
                         action: #selector(shinyButtonClicked),
                         for: .touchUpInside)
        button.setTitle("See it's shiny version!",
                        for: .normal)
        return button
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        
        guard let url = pokemon?.species?.url else { return }
        
        service.getSpecies(url: url) { (description) in
            
            self.infoLabel.text = description
        }
    }
    
    @objc func shinyButtonClicked() {
        
        pressedButton = !pressedButton
        
        guard let shiny         = self.pokemon?.sprites?.shiny,
              let frontSprite   = self.pokemon?.sprites?.front
        else { return }

        if pressedButton {
            self.imageView.kf.setImage(with: URL(string: shiny))
            shinyButton.setTitle("Return to it's normal version!",
                                 for: .normal)
            print("Hi there, shiny!")
        } else {
            self.imageView.kf.setImage(with: URL(string: frontSprite))
            shinyButton.setTitle("See it's shiny version!",
                                 for: .normal)
            print("Image returned!")
        }
    }
}

