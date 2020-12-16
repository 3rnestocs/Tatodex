//  Service.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import Alamofire

class Service: Codable {

    var mainAPI = "https://pokeapi.co/api/v2/pokemon?limit=20"
    
    // MARK: - MainAPI call
    func fetchPokes(handler: @escaping (Pokemon) -> Void) {
        
        AF.request(mainAPI).validate().responsePokemon { (response) in
            
            guard let data            = response.value,
                  let results   = data.results else { return }
            
            print("You've got \(results.count) pokemons successfully")
            
            for poke in results {
                
                guard let pokeUrl = poke.url else { return }
                
                AF.request(pokeUrl).validate().responsePokemon { (pokes) in
                    
                    guard let pokeData = pokes.value else { return }
                    
                    /// PokeData already has the JSON response according to the Pokemon model, and this handler pass every
                    /// poke on the API call
                    handler(pokeData)
                }
            }
        }.resume()
    }
    
    func getTypes(typesUrl: String, handler: @escaping([CustomDescription]) -> Void) {
        
        namArray = []
        
        AF.request(typesUrl).validate().responseTypes { (types) in
            
            guard let typeData = types.value,
                  let typeNames = typeData.names else { return }
            
            handler(typeNames)
        }
    }
    
    func getSpecies(url: String, handler: @escaping(String) -> Void) {
        
        AF.request(url).validate().responseSpecies { (response) in
            
            do {
                guard let data          = response.value,
                      let descriptArray = data.description
                else { return }
                
                print("You've got \(descriptArray.count) species successfully")
     
                for desc in descriptArray {
                    
                    /// This doesn't have an else statement because it runs all the descriptArray, and it would print a DEBUG msg for
                    /// every wrong case. This way the console remains clean.
                    guard let description = desc.text!.components(separatedBy: .whitespacesAndNewlines) as? [String]? else { return }
                    let fullword = description!.joined(separator: " ")
                    
                    if languageClickChecker {
                        if desc.language?.name == "es" {
                            handler(fullword)
                        }
                    } else {
                        if desc.language?.name == "en" {
                            handler(fullword)
                        }
                    }
                }
            } catch {
                print("DEBUG: Error with the description. \(error.localizedDescription) ")
            }
        }.resume()
    }
}
