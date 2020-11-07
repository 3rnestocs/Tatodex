//
//  TatodexCell.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/5/20.
//

import UIKit

class TatodexCell: UICollectionViewCell {
    
//MARK: - Properties
    
    var pokemon: Pokemon? {
        didSet {
            nameLabel.text = pokemon?.name?.capitalized
            imageView.image = pokemon?.image
        }
    }
    
    var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.backgroundColor = Colors.myGray
        imageView.contentMode = .scaleAspectFit
        
        return imageView
        
    }()
    
    lazy var nameContainerView: UIView = {
        
       let nameView = UIView()
        nameView.backgroundColor = Colors.softRed
        nameView.addSubview(nameLabel)
        nameLabel.center(inView: nameView)
        
        return nameView
    }()
    
    var nameLabel: UILabel = {
       
        let pokeLabel = UILabel()
        pokeLabel.text = "Lucario"
        pokeLabel.textColor = Colors.myWhite
        pokeLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        
        return pokeLabel
        
    }()
    
    //MARK: - Init stuff

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure views
    func configureViewComponents() {
        
        addSubview(imageView)
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
        
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: self.frame.height - 32)
        
        addSubview(nameContainerView)
        nameContainerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)
    }
}
