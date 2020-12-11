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
    
    //  This whole block assigns the attributes that will be shown at the InfoView pop-up
    //  It makes the positioning of every element possible
    var pokemon: Pokemon? {
        didSet {
            guard let pokemon   = self.pokemon,
                  let type      = pokemon.types,
                  let type1     = type[0].type?.name?.capitalized,
                  let stats     = pokemon.stats,
                  let attack    = stats[1].baseStat,
                  let defense   = stats[2].baseStat,
                  let id        = pokemon.id,
                  let height    = pokemon.height,
                  let weight    = pokemon.weight,
                  let imageUrl  = pokemon.sprites?.front else { return }
            
            if id == pokemon.id {
                imageView.kf.setImage(with: URL(string: imageUrl))
            }
            
            if type.count == 1 {
                configureLabel(label: typeLabel, title: "Type", details: type1)
            } else {
                guard let type2 = type[1].type?.name?.capitalized else { return }
                let myTypes = "\(type1) and \(type2)"

                configureLabel(label: typeLabel, title: "Type", details: myTypes)
            }
            
            nameLabel.text = pokemon.name?.capitalized

            configureLabel(label: pokedexIdLabel,   title: "Pokedex Id",    details: "\(id)")
            configureLabel(label: heightLabel,      title: "Height",        details: "\(height)")
            configureLabel(label: defenseLabel,     title: "Defense",       details: "\(defense)")
            configureLabel(label: weightLabel,      title: "Weight",        details: "\(weight)")
            configureLabel(label: attackLabel,      title: "Base Attack",   details: "\(attack)")
        }
    }
    
    let skillLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor    = Colors.softRed
        view.layer.cornerRadius = 5
        view.addSubview(nameLabel)
        nameLabel.center(inView: view)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font      = UIFont.systemFont(ofSize: 24,
                                            weight: .thin)
        label.text      = "Lucario"
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let defenseLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let pokedexIdLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let attackLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let hpLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let speedLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let specialAttackLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let specialDefenseLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let infoButton: UIButton = {
        let button                  = UIButton(type: .system)
        button.backgroundColor      = Colors.softRed
        button.titleLabel?.font     = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius   = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white,
                             for: .normal)
        button.setTitle("View More Info",
                        for: .normal)
        button.addTarget(self,
                         action: #selector(handleViewMoreInfo),
                         for: .touchUpInside)
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
    
    // MARK: - Layout settings
    func configureLabel(label: UILabel, title: String, details: String) {
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title):  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: Colors.softRed!]))
        
        attributedText.append(NSAttributedString(string: "\(details)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        label.attributedText = attributedText
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
        separatorView.backgroundColor   = Colors.myWhite
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
        separatorView.backgroundColor   = Colors.myWhite
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

