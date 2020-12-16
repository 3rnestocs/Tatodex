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
            
            if id == pokemon.id {
                imageView.kf.setImage(with: URL(string: imageUrl))
            }
            
            getMytypes(typeUrl: typeUrl)
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
    
    // MARK: - Helper functions
    private func configureLabel(label: UILabel, title: String, details: String) {
        
        var attributedText = NSMutableAttributedString()
        
        if languageClickChecker {
            infoButton.setTitle("Ver mas informacion", for: .normal)
        } else {
            infoButton.setTitle("View More Info", for: .normal)
        }
        
        if themeClickCkecker {
             attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title):  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: Colors.darkBlue!]))
        } else {
            attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title):  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: Colors.darkRed!]))
        }
        
        attributedText.append(NSAttributedString(string: "\(details)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        label.attributedText = attributedText
    }
    
    func getMytypes(typeUrl: [String]) {
        
        for url in typeUrl {
            service.getTypes(typesUrl: url) { [self] (names) in

                for name in names {
                    
                    guard let types = name.name else { return }
                    namArray.append(types)
                    
                    if languageClickChecker {
                        if name.language?.name == "es" {
                            guard let firstType = namArray[4] as String? else { return }
                            if namArray.count > 6 {
                                guard let secondType = namArray[11] as String? else { return }

                                let myTypes     = "\(firstType) y \(secondType)"
                                configureLabel(label: typeLabel,  title: "Tipos", details: myTypes)
                            } else {
                                configureLabel(label: typeLabel, title: "Tipo", details: firstType)
                            }
                        }
                    } else {
                        if name.language?.name == "en" {
                            
                            guard let firstType = namArray[6] as String? else { return }
                            if namArray.count > 6 {
                                guard let secondType = namArray.last else { return }
                                if firstType == secondType {
                                    configureLabel(label: typeLabel, title: "Type", details: firstType)
                                } else {
                                    let myTypes     = "\(firstType) and \(secondType)"
                                    configureLabel(label: typeLabel,  title: "Types", details: myTypes)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - InfoView Layout
    func configureViewComponents() {
        
        backgroundColor             = .white
        self.layer.masksToBounds    = true
        
        addSubview(nameContainerView)
        nameContainerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        addSubview(imageView)
        imageView.anchor(top: nameContainerView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 12, paddingBottom: 16, paddingRight: 0, width: 200, height: 200)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(typeLabel)
        typeLabel.anchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 190, height: 0)
        
        addSubview(pokedexIdLabel)
        pokedexIdLabel.anchor(top: imageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        let separatorView               = UIView()
        separatorView.backgroundColor   = Colors.mainWhite
        addSubview(separatorView)
        separatorView.anchor(top: typeLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 1)
        
        addSubview(heightLabel)
        heightLabel.anchor(top: separatorView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(weightLabel)
        weightLabel.anchor(top: heightLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(defenseLabel)
        defenseLabel.anchor(top: separatorView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        addSubview(attackLabel)
        attackLabel.anchor(top: defenseLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        addSubview(infoButton)
        infoButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0    , width: 0, height: 50)
    }
    
    //MARK: - InfoController Layout
    func configureViewForInfoController() {
        addSubview(typeLabel)
        typeLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(pokedexIdLabel)
        pokedexIdLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)

        let separatorView               = UIView()
        separatorView.backgroundColor   = Colors.mainWhite
        addSubview(separatorView)
        separatorView.anchor(top: typeLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 1)
        
        addSubview(heightLabel)
        heightLabel.anchor(top: separatorView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(weightLabel)
        weightLabel.anchor(top: heightLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(skillLabel)
        skillLabel.anchor(top: weightLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //MARK: - Stats
        addSubview(defenseLabel)
        defenseLabel.anchor(top: separatorView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        addSubview(attackLabel)
        attackLabel.anchor(top: defenseLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        addSubview(hpLabel)
        hpLabel.anchor(top: skillLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        addSubview(speedLabel)
        speedLabel.anchor(top: hpLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        addSubview(specialAttackLabel)
        specialAttackLabel.anchor(top: skillLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(specialDefenseLabel)
        specialDefenseLabel.anchor(top: specialAttackLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}

