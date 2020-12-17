//
//  TatodexCell.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/5/20.
//

import UIKit
import Kingfisher

protocol TatodexCellDelegate {
    func presentInfoView(withPokemon pokemon: Pokemon)
}

class TatodexCell: UICollectionViewCell {
    
    //MARK: - Properties
    var delegate: TatodexCellDelegate?
    
    var pokemon: Pokemon? {
        didSet {
            guard let id = pokemon?.id,
                  let imageUrl = pokemon?.sprites?.front
            else { return }
            
            if id == pokemon?.id {
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: URL(string: imageUrl))
            }
            nameLabel.text = pokemon?.name?.capitalized
        }
    }
    
    var imageView: UIImageView = {
        
        let imageView               = UIImageView()
        imageView.backgroundColor   = Colors.mainGray
        imageView.contentMode       = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameContainerView: UIView = {
        
       let nameView = UIView()
        nameView.addSubview(nameLabel)
        nameLabel.center(inView: nameView)
        return nameView
    }()
    
    var nameLabel: UILabel = {
       
        let pokeLabel       = UILabel()
        pokeLabel.text      = "Lucario"
        pokeLabel.textColor = Colors.mainWhite
        pokeLabel.translatesAutoresizingMaskIntoConstraints = false
        pokeLabel.font = UIFont.systemFont(ofSize: 12,
                                           weight: .semibold)
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
        self.clipsToBounds      = true
        
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: self.frame.height - 32)
        
        addSubview(nameContainerView)
        nameContainerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
}
