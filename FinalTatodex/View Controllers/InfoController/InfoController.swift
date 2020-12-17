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
            guard let pokemon = pokemon,
                  let sprites = pokemon.sprites?.front,
                  let stats   = pokemon.stats
            else { return }
            
            let statNum = stats.compactMap { $0.baseStat }
            
            navigationItem.title = pokemon.name?.capitalized
            infoView.pokemon     = pokemon
            DispatchQueue.main.async {
                self.imageView.kf.setImage(with: URL(string: sprites))
            }
            
            if languageClickChecker {
                configuresLabel(label: infoView.hpLabel,    title: "HP", details: "\(statNum[0])")
                configuresLabel(label: infoView.speedLabel, title: "Velocidad", details: "\(statNum[5])")
                configuresLabel(label: infoView.specialAttackLabel,
                                title: "Ataque especial",   details: "\(statNum[3])")
                configuresLabel(label: infoView.specialDefenseLabel,
                                title: "Defensa especial",  details: "\(statNum[4])")
            } else {
                configuresLabel(label: infoView.hpLabel,    title: "HP", details: "\(statNum[0])")
                configuresLabel(label: infoView.speedLabel, title: "Speed", details: "\(statNum[5])")
                configuresLabel(label: infoView.specialAttackLabel,
                                title: "Special-Attack",   details: "\(statNum[3])")
                configuresLabel(label: infoView.specialDefenseLabel,
                                title: "Special-Defense",  details: "\(statNum[4])")
            }
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
        if !languageClickChecker {
            button.setTitle("See it's shiny version!",
                            for: .normal)
        } else {
            button.setTitle("Mira la version shiny!",
                            for: .normal)
        }
        return button
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        
        guard let url = pokemon?.species?.url,
              let skillUrls = pokemon?.abilities?.compactMap({$0.ability?.url!}) else { return }
        
        DispatchQueue.main.async {
            self.getSkills(urls: skillUrls)
            service.getSpecies(url: url) { (description) in
                
                self.infoLabel.text = description
            }
        }
    }
    
    // MARK: - Helper functions
    
    private func getSkills(urls: [String]) {
        
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
    
    private func configuresLabel(label: UILabel, title: String, details: String) {
        
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
    
    // MARK: - Selector
    
    @objc func shinyButtonClicked() {
        
        pressedButton = !pressedButton
        
        guard let shiny         = self.pokemon?.sprites?.shiny,
              let frontSprite   = self.pokemon?.sprites?.front
        else { return }

        if pressedButton {
            self.imageView.kf.setImage(with: URL(string: shiny))
            
            if languageClickChecker {
                shinyButton.setTitle("Vuelve a ver al original!",
                                     for: .normal)
            } else {
                shinyButton.setTitle("Return to it's normal version!",
                                     for: .normal)
            }
        } else {
            self.imageView.kf.setImage(with: URL(string: frontSprite))
            
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


