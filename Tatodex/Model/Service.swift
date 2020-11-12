//
//  Service.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import Alamofire

class Service: Codable {
    
    var mainAPI = "https://pokeapi.co/api/v2/pokemon?limit=151"
    var secondAPI = "https://pokedex-bb36f.firebaseio.com/pokemon.json"
    
    // MARK: - MainAPI call
    func fetchPokes(handler: @escaping (Pokemon) -> Void) {
        
        var pokeUrls = [String]()
        
        AF.request(mainAPI).validate().responsePokemon { (response) in
            
            let data = response.value
            let results = data?.results
            
            for poke in results! {
                pokeUrls.append(poke.url!)
            }
            
            for url in pokeUrls {
                
                AF.request(url).validate().responsePokemon { (pokes) in
                    
                    guard let pokeData = pokes.value else { return }

                    handler(pokeData)
                }
            }
        }.resume()
    }
    
    // MARK: - SecondAPI call
    func getOtherPokes(handler: @escaping ([Pokemon]) -> Void) {
        
        var pokemonArray = [Pokemon]()
        
        AF.request(secondAPI).responseJSON { (response) in
   
            do {
                guard let pokeFetched = response.value as? [AnyObject] else { return }
                
                print("You have \(pokeFetched.count - 1) pokemon listed by now.")

                //  Get all the elements of the pokemon objects
                for (key, result) in pokeFetched.enumerated() {
                    if let dictionary = result as? [String: AnyObject] {
                        let pokemon = Pokemon(id: key, dictionary: dictionary)
                        
                            pokemonArray.append(pokemon)
                            
//                              Sort the pokemons on the view by id-order
                            pokemonArray.sort { (poke1, poke2) -> Bool in
                                return poke1.id! < poke2.id!
                        }
                        handler(pokemonArray)
                    }
                }
            } catch {
                print("There was an error: \(error)")
            }
        }.resume()
    }
}

// MARK: - Alamofire response handlers

extension DataRequest {

    @discardableResult
    func responsePokemon(queue: DispatchQueue? = nil, completionHandler: @escaping (AFDataResponse<Pokemon>) -> Void) -> Self {
        return responseDecodable(queue: queue ?? .main, completionHandler: completionHandler)
    }
}
