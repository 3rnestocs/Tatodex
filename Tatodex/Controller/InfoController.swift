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
    var skills: String?
    var ids: Int?
    var abilities: [String]? {
        didSet {
 
            for skill in abilities! {
                skills = skill.capitalized
            }
            
            if controller.pokeIds == ids {
                infoView.configureLabel(label: infoView.skillLabel, title: "Skills", details: "\(skills!)")
            }
        }
    }
    
    var pokemon: Pokemon? {
        didSet {
            navigationItem.title = pokemon?.name?.capitalized
            imageView.image = pokemon?.image
            infoLabel.text = pokemon?.description
            infoView.pokemon = pokemon
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
    
    lazy var evolutionView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.softRed
        
        view.addSubview(evoLabel)
        evoLabel.translatesAutoresizingMaskIntoConstraints = false
        evoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        evoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    let evoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Next Evolution: Charmeleon"
        return label
    }()
    
    let firstEvoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = Colors.hardRed
        return iv
    }()
    
    let secondEvoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = Colors.hardRed
        return iv
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        fetchAbilities()
    }
    
    // MARK: - Layout disposure
    func configureViewComponents() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(imageView)
        view.addSubview(evolutionView)
        view.addSubview(firstEvoImageView)
        view.addSubview(secondEvoImageView)
                
        //  Set up for small devices (Height < 700pts)
        if view.frame.height <= 700 {
            imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
            
            evolutionView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 166, paddingRight: 0, width: 0, height: 30)
            
            firstEvoImageView.anchor(top: evolutionView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
            
            secondEvoImageView.anchor(top: evolutionView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 32, width: 120, height: 120)
            
            infoLabel.font = UIFont.systemFont(ofSize: 14)
            evoLabel.font = UIFont.systemFont(ofSize: 15)
            
        } else {
            imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
            
            evolutionView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 0, height: 50)

            firstEvoImageView.anchor(top: evolutionView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
            
            secondEvoImageView.anchor(top: evolutionView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 32, width: 30, height: 30)
            
            infoLabel.font = UIFont.systemFont(ofSize: 16)
            evoLabel.font = UIFont.systemFont(ofSize: 18)
        }
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        infoLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        view.addSubview(infoView)
        infoView.anchor(top: infoLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
