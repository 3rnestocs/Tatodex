//
//  Service.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import Alamofire
import SwiftyJSON
import UIKit

class Service {
    
    //MARK: - Main parsing
    let baseURL = "https://pokedex-bb36f.firebaseio.com/pokemon.json"
    let skillPokes = "https://pokeapi.co/api/v2/pokemon?limit=151"
    static let shared = Service()
    
    func fetchPokes(handler: @escaping ([Pokemon]) -> Void) {
        var pokemonArray = [Pokemon]()
        
        AF.request(baseURL).responseJSON { (response) in
   
            do {

                guard let pokeFetched = response.value as? [AnyObject] else { return }
                
                print("You have \(pokeFetched.count - 1) pokemon listed by now.")

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

//MARK: - Skills parsing
extension Service {
    
    func fetchSkills(handler: @escaping ([String], Int) -> Void) {
        
        AF.request(skillPokes).validate().response { (response) in
            
            do {
                guard let pokeList = response.data else { return }
                
                let decoded = try JSONDecoder().decode(Pokemons.self, from: pokeList)
                let pokeResults = decoded.results
                
                for poke in pokeResults! {
                    
                    let pokeEndpoint = poke.url!
                    
                    AF.request(pokeEndpoint).responseJSON { (response) in
                        
                        do {
                            guard let urlData = response.data else { return }
                            
                            let json = try JSON(data: urlData)
                            let ids = json["id"].intValue
                            let abilities = json["abilities"].arrayValue.map {$0["ability"]["name"].stringValue}
                            
                            handler(abilities, ids)
                            
                        } catch {
                            print(error)
                        }
                    }
                }
            } catch {
                print(error)
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

extension InfoController {
    
    func fetchAbilities() {
        Service.shared.fetchSkills { (skill, id) in
            
            if skill.isEmpty {
                
                print("There was an error, the skills didn't make it.")
            } else {
                
                self.abilities = skill
                self.ids = id
            }
        }
    }
}
