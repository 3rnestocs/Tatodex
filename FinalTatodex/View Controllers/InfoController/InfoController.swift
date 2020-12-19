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
            self.configureSkills(urls: skillUrls)
            service.getSpecies(url: url) { (result) in
                
                switch result {
                case .success(let description):
                    self.infoLabel.text = description
                case .failure(let error):
                    print("DEBUG \(NetworkResponse.failed): \(error)" )
                }
            }
        }
    }
}


