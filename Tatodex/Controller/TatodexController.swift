//
//  TatodexController.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/4/20.
//

import UIKit

//  This is a reusable cell identifier to minimize human error while using it
private let reuseIdentifier = "TatodexCell"

class TatodexController: UICollectionViewController, InfoViewDelegate {
    
    //MARK: - Properties
//    var pokemon: Pokemon?
    var pokemons = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    let service = Service()
    var searchBar: UISearchBar!
    var inSearchMode = false
    
    let infoView: InfoView = {
        let view = InfoView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    //  This blurs the CollectionView when InfoView shows up
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
    }
    
    //MARK: - Selectors
    @objc func searchTapped() {
        configureSearchBar(showSearch: true)
    }
    
    @objc func handleDismissal() {
        dismissInfoView(pokemon: nil)
    }
}

//MARK: - Helper functions
extension TatodexController {

    func configureViewStuff() {
        
        collectionView.backgroundColor = Colors.hardRed
        
        navigationController?.navigationBar.barTintColor = Colors.softRed
        navigationController?.navigationBar.barStyle     = .black
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "Tatodex"
        
        configureSearchBarButton()

        collectionView.register(TatodexCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        visualEffectView.alpha = 0
        
        //  Allows to dismiss the InfoView tapping outside
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDismissal))
            self.visualEffectView.addGestureRecognizer(gesture)
    }
    
    func configureSearchBar(showSearch: Bool) {
        
        //  This refactoring allows me to enable/disable the search button when InfoView shows up
        if showSearch {
            searchBar = UISearchBar()
            searchBar.delegate = self
            searchBar.sizeToFit()
            searchBar.showsCancelButton = true
            searchBar.becomeFirstResponder()
            searchBar.tintColor = Colors.hardRed
            searchBar.backgroundColor = Colors.myGray
            searchBar.placeholder = "Search your favorite pokemon"
            
            //  The search button goes away when the search field appears
            navigationItem.rightBarButtonItem = nil
            navigationItem.titleView = searchBar
        } else {
            navigationItem.titleView = nil
            configureSearchBarButton()
            inSearchMode = false
            collectionView.reloadData()
        }
    }
    
    func configureSearchBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        navigationItem.rightBarButtonItem?.tintColor = Colors.myGray
    }
    
    func showInfoController(withPoke pokemon: Pokemon) {
        
        let controller = InfoController()
        controller.pokemon = pokemon
        self.navigationController?.pushViewController(controller
                                                      , animated: true)
    }
    
    //  This allows me to click outside InfoView to dismiss that screen
    func dismissInfoView(pokemon: Pokemon?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.infoView.alpha = 0
            self.infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.infoView.removeFromSuperview()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            guard let pokemon = pokemon else { return }
            self.showInfoController(withPoke: pokemon)
        }
    }
    
    func fetchPokemons() {
        service.fetchPokes { (poke) in
            DispatchQueue.main.async {
                self.pokemons.append(poke)
                self.collectionView.reloadData()
            }
        }
        
//        service.getOtherPokes { (pokes) in
//            DispatchQueue.main.async {
//                self.pokemons = pokes
//                self.collectionView.reloadData()
//
////                print(self.pokemons)
//            }
//        }
    }
}
    
extension TatodexController: UICollectionViewDelegateFlowLayout {
        
    //MARK: - CollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 12, bottom: 32, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 2
        return CGSize(width: width, height: width)
    }

    //MARK: - CollectionView DataSource/Delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPokemon.count : pokemons.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TatodexCell
        
        cell.pokemon = inSearchMode ? filteredPokemon[indexPath.row] : pokemons[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let poke = inSearchMode ? filteredPokemon[indexPath.row] : pokemons[indexPath.row]
        showInfoController(withPoke: poke)
    }
}

//MARK: SearchBar delegate
extension TatodexController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //  This checks if the user search something, and if it does, filters the pokemon
        //  in the CollectionView by name
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            filteredPokemon = pokemons.filter({ $0.name?.range(of: searchText.lowercased()) != nil })
            collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        configureSearchBar(showSearch: false)
    }
}

//MARK: - InfoViewlDelegate
extension TatodexController: TatodexCellDelegate {
    
    func presentInfoView(withPokemon pokemon: Pokemon) {
        
        //  When the InfoView shows up, the search button goes off
        configureSearchBar(showSearch: false)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        //  Setting up the InfoView disposure
        view.addSubview(infoView)
        infoView.configureViewComponents()
        infoView.delegate = self
        infoView.pokemon = pokemon
        infoView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 64, height: 480)
        infoView.layer.cornerRadius = view.frame.width / 6
        infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        
        infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        infoView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.visualEffectView.alpha = 1
            self.infoView.alpha = 1
            self.infoView.transform = .identity
        }
    }
}



