//
//  InfoController.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/8/20.
//

import UIKit
import Alamofire

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
            
            self.configuresLabel(label: self.infoView.skillLabel,
                                         title: "Skills",           details: names)
            self.configuresLabel(label: self.infoView.hpLabel,
                                         title: "HP",               details: "\(statNum[0])")
            self.configuresLabel(label: self.infoView.speedLabel,
                                         title: "Speed",            details: "\(statNum[5])")
            self.configuresLabel(label: self.infoView.specialAttackLabel,
                                         title: "Special-Attack",   details: "\(statNum[3])")
            self.configuresLabel(label: self.infoView.specialDefenseLabel,
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
    
    private func configuresLabel(label: UILabel, title: String, details: String) {
        
        var attributedText = NSMutableAttributedString()
        
        if clickCheck {
            attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title):  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: Colors.darkBlue!]))
            
            shinyButton.backgroundColor = Colors.darkBlue
       } else {
           attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title):  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: Colors.darkRed!]))
        
        shinyButton.backgroundColor = Colors.darkRed
       }
        
        attributedText.append(NSAttributedString(string: "\(details)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        label.attributedText = attributedText
    }
    
    // MARK: - Selector
    
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


