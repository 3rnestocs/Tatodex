//
//  Layouts.swift
//  FinalTatodex
//
//  Created by Ernesto Jose Contreras Lopez on 12/16/20.
//

import UIKit

extension InfoView {
    
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
        skillLabel.numberOfLines = 0
        skillLabel.anchor(top: weightLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 350, height: 0)
        
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
