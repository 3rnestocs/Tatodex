//
//  InfoController.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/8/20.
//

import UIKit

class InfoController: UIViewController {
    
    // MARK: - Properties
    var controller = TatodexController()
    var pokemon: Pokemon? {
        didSet {
            guard let pokemon = pokemon, let sprites = pokemon.sprites?.front else { return }
            
            navigationItem.title = pokemon.name?.capitalized
            infoView.pokemon = pokemon
            DispatchQueue.main.async {
                self.imageView.kf.setImage(with: URL(string: sprites))
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
    
    lazy var endView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.softRed
        
        view.addSubview(endLabel)
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        endLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    let endLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Thanks for watching"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        
        fetchPokemons { (names, statNum) in
            self.pokemon?.statNum = statNum
            self.infoView.configureLabel(label: self.infoView.skillLabel, title: "Skills", details: names)
            self.infoView.configureLabel(label: self.infoView.hpLabel, title: "HP", details: "\(statNum[0])")
            self.infoView.configureLabel(label: self.infoView.speedLabel, title: "Speed", details: "\(statNum[5])")
            self.infoView.configureLabel(label: self.infoView.specialAttackLabel, title: "Special-Attack", details: "\(statNum[3])")
            self.infoView.configureLabel(label: self.infoView.specialDefenseLabel, title: "Special-Defense", details: "\(statNum[4])")
        }
    }
    
    // MARK: - Layout disposure
    func configureViewComponents() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(imageView)
        view.addSubview(endView)
                
        //  Set up for small devices (Height < 700pts)
        if view.frame.height <= 700 {
            imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
            
            endView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
            
            infoLabel.font = UIFont.systemFont(ofSize: 15)
            
        } else {
            imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)

            infoLabel.font = UIFont.systemFont(ofSize: 17)
            
            endView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 80, paddingRight: 0, width: 0, height: 50)
        }
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        infoLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        view.addSubview(infoView)
        infoView.anchor(top: infoLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    /// Fetching pokemon abilities
    func fetchPokemons(handler: @escaping (String, [Int]) -> Void) {
        controller.service.fetchPokes { (poke) in
            guard poke.id == self.pokemon?.id else { return }
            self.pokemon? = poke
            let names = poke.abilities?.compactMap { $0.ability?.name?.capitalized }.joined(separator: ", ")
            
            guard let stats = poke.stats else { return }
            let statNum = stats.compactMap { $0.baseStat }
            
            handler(names ?? "-", statNum)
        }
    }
}
