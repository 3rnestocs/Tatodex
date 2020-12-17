//
//  InfoView.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/7/20.
//

import UIKit

protocol InfoViewDelegate {
    func dismissInfoView(pokemon: Pokemon?)
}

class InfoView: UIView {
    
    // MARK: - Properties
    var delegate: InfoViewDelegate?
    
    ///  This whole block assigns the attributes that will be shown at the InfoView pop-up
    ///  It makes the positioning of every element possible
    var pokemon: Pokemon? {
        didSet {
            guard let pokemon   = self.pokemon,
                  let typeUrl = pokemon.types?.compactMap({$0.type?.url!}),
                  let imageUrl  = pokemon.sprites?.front,
                  let stats     = pokemon.stats,
                  let attack    = stats[1].baseStat,
                  let defense   = stats[2].baseStat,
                  let height    = pokemon.height,
                  let weight    = pokemon.weight,
                  let id        = pokemon.id else { return }
            
            getMytypes(typeUrl: typeUrl)
            
            if id == pokemon.id {
                imageView.kf.setImage(with: URL(string: imageUrl))
            }
            
            nameLabel.text = pokemon.name?.capitalized

            if languageClickChecker {
                
                configureLabel(label: pokedexIdLabel, title: "ID Pokedex",  details: "\(id)")
                configureLabel(label: heightLabel,    title: "Estatura",    details: "\(height)")
                configureLabel(label: defenseLabel,   title: "Defensa",     details: "\(defense)")
                configureLabel(label: weightLabel,    title: "Peso",        details: "\(weight)")
                configureLabel(label: attackLabel,    title: "Ataque base", details: "\(attack)")
            } else {
                
                configureLabel(label: pokedexIdLabel, title: "Pokedex ID",  details: "\(id)")
                configureLabel(label: heightLabel,    title: "Height",      details: "\(height)")
                configureLabel(label: defenseLabel,   title: "Defense",     details: "\(defense)")
                configureLabel(label: weightLabel,    title: "Weight",      details: "\(weight)")
                configureLabel(label: attackLabel,    title: "Base Attack", details: "\(attack)")
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor    = Colors.lightRed
        view.layer.cornerRadius = 5
        view.addSubview(nameLabel)
        nameLabel.center(inView: view)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font      = UIFont.systemFont(ofSize: 24, weight: .thin)
        label.text      = "Lucario"
        return label
    }()
    
    let specialDefenseLabel = UILabel()
    let specialAttackLabel  = UILabel()
    let pokedexIdLabel      = UILabel()
    let defenseLabel        = UILabel()
    let heightLabel         = UILabel()
    let weightLabel         = UILabel()
    let attackLabel         = UILabel()
    var skillLabel          = UILabel()
    let speedLabel          = UILabel()
    var typeLabel           = UILabel()
    let hpLabel             = UILabel()
    
    let infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleViewMoreInfo), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.titleLabel?.font   = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor    = Colors.lightRed
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleViewMoreInfo() {
        guard let pokemon = self.pokemon else { return }
        delegate?.dismissInfoView(pokemon: pokemon)
    }
}
