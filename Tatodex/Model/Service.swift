//
//  Service.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import Alamofire
import UIKit

class Service {
    
    //MARK: - Main parsing
    let baseURL = "https://pokedex-bb36f.firebaseio.com/pokemon.json"
    static let shared = Service()
    
    func fetchPokes(handler: @escaping ([Pokemon]) -> Void) {
        var pokemonArray = [Pokemon]()
        
        AF.request(baseURL).responseJSON { (response) in
   
            do {

                guard let pokeFetched = response.value as? [AnyObject] else { return }
                
                print("You have \(pokeFetched.count) pokemon listed by now.")

                //  Get all the elements of the pokemon objects
                for (key, result) in pokeFetched.enumerated() {
                    if let dictionary = result as? [String: AnyObject] {
                        var pokemon = Pokemon(id: key, dictionary: dictionary)
                        
                        guard let imageURL = pokemon.imageUrl else { return }
                        
                        self.fetchImages(withUrl: imageURL) { (image) in
                            pokemon.image = image
                            pokemonArray.append(pokemon)
                            
                            //  Sort the pokemons on the view by id-order
                            pokemonArray.sort { (poke1, poke2) -> Bool in
                                return poke1.id! < poke2.id!
                            }
                            
                            handler(pokemonArray)
                        }
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    //MARK: - Image parsing
    private func fetchImages(withUrl urlString: String, handler: @escaping(UIImage) -> Void) {
        
        //  Get a url as a parameter, so I can use it on fetchPokes
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url).response { (response) in
            
            guard let data = response.data else { return }
            guard let image = UIImage(data: data) else { return }
            
            handler(image)
            
            if let error = response.error {
                print("There was an error downloading the image. Check it out: \n \(error)")
            }
        }.resume()
    }
}

extension TatodexController {
    
    //MARK: - Fetching
    func fetchPokemons() {
        
        Service.shared.fetchPokes { (pokemon) in
            DispatchQueue.main.async {
                self.pokemon = pokemon
                self.collectionView.reloadData()
            }
        }
        
    }
    
}
