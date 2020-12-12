//
//  TatodexController.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/4/20.
//

import UIKit

class TatodexController: UIViewController, InfoViewDelegate {
    
    //MARK: - Properties
    var pokemons = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var searchBar: UISearchBar!
    var inSearchMode = false
    
    var viewBigScreen: UIView? = {
        
        let view = UIView()
        view.backgroundColor = Colors.mainBlack
        return view
    }()
    
    var collectionViewPokemon: UICollectionView? = {

        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero,
                                  collectionViewLayout: layout)
        cv.register(TatodexCell.self,
                    forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    let infoView: InfoView = {
        let view = InfoView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    let buttonChangeTheme: UIButton? = {
        let button = UIButton()
        button.setTitle("Change to blue theme", for: .normal)
        button.addTarget(self, action: #selector(themeButtonClicked), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderWidth = 3
        button.layer.borderColor = Colors.mainBlack?.cgColor
        button.backgroundColor = Colors.darkBlue
        button.tintColor = Colors.mainWhite
       return button
    }()
    
    let buttonChangeLanguage: UIButton? = {
        let button = UIButton()
        button.setTitle("Switch to spanish", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderWidth = 3
        button.layer.borderColor = Colors.mainBlack?.cgColor
        button.backgroundColor = Colors.darkRed
        button.tintColor = Colors.mainWhite
       return button
    }()
    
    ///  This blurs the CollectionView when InfoView shows up
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewStuff()
        fetchPokemons()
        setViews()
    }
}
    
extension TatodexController: UICollectionViewDelegateFlowLayout,
                             UICollectionViewDataSource,
                             UICollectionViewDelegate {
        
    //MARK: - CollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 12, bottom: 32, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 2
        return CGSize(width: width, height: width)
    }

    //MARK: - CollectionView DataSource/Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPokemon.count : pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TatodexCell
        
        cell.pokemon = inSearchMode ? filteredPokemon[indexPath.row] : pokemons[indexPath.row]
        cell.delegate = self
        
        if clickCheck {
            cell.nameContainerView.backgroundColor = Colors.lightBlue
        } else {
            cell.nameContainerView.backgroundColor = Colors.lightRed
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let poke = inSearchMode ? filteredPokemon[indexPath.row] : pokemons[indexPath.row]
        showInfoController(withPoke: poke)
    }
}



