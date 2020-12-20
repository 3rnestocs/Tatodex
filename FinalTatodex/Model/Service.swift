//  Service.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import Alamofire

class Service: Codable {

    var mainAPI = "https://pokeapi.co/api/v2/pokemon?limit=800&offset=50"
    
    // MARK: - MainAPI call
    func fetchPokes(handler: @escaping (Result<Pokemon, Error>) -> Void) {
        
        AF.request(mainAPI).validate().responsePokemon { (response) in

            if let error = response.error {
                
                print("DEBUG \(NetworkResponse.badRequest): \(error)")
                handler(.failure(error))
            }
            
            do {
                guard let data            = response.value,
                      let results   = data.results else { return }
                
                print("You've got \(results.count) pokemons successfully")
                
                for poke in results {
                    
                    guard let pokeUrl = poke.url else { return }
                    
                    AF.request(pokeUrl).validate().responsePokemon { (pokes) in
                        
                        guard let pokeData = pokes.value else { return }
                        
                        /// PokeData already has the JSON response according to the Pokemon model, and this handler pass every
                        /// poke on the API call
                        handler(.success(pokeData))
                    }
                }
            } catch {
                print("DEBUG \(NetworkResponse.noJSON): \(error)")
            }
        }.resume()
    }
    
    func getTypesOrSkills(url: String, handler: @escaping(Result<[CustomDescription], Error>) -> Void) {
        
        typeNameArray = []
        skillNameArray = []
        
        AF.request(url).validate().responseTypesOrSkills { (types) in
            
            if let error = types.error {
                
                print("DEBUG \(NetworkResponse.badRequest): \(error)")
                handler(.failure(error))
            }
            
            do {
                guard let typeData = types.value,
                      let anyNames = typeData.names else { return }
                
                handler(.success(anyNames))
            } catch {
                print("DEBUG \(NetworkResponse.noJSON): \(error)")
            }
        }
    }
    
    func getSpecies(url: String, handler: @escaping(Result<String, Error>) -> Void) {
        
        AF.request(url).validate().responseSpecies { (response) in
            
            if let error = response.error {
                
                print("DEBUG \(NetworkResponse.badRequest): \(error)")
                handler(.failure(error))
            }
            
            do {
                guard let data          = response.value,
                      let descriptArray = data.description
                else { return }
                
                print("\(descriptArray.count) species for descriptions registered. All working.")
     
                for desc in descriptArray {
                    
                    /// This doesn't have an else statement because it runs all the descriptArray, and it would print a DEBUG msg for
                    /// every wrong case. This way the console remains clean.
                    guard let description = desc.text!.components(separatedBy: .whitespacesAndNewlines) as [String]? else { return }
                    let fullword = description.joined(separator: " ")
                    
                    if languageClickChecker {
                        if desc.language?.name == "es" {
                            handler(.success(fullword))
                        }
                    } else {
                        if desc.language?.name == "en" {
                            handler(.success(fullword))
                        }
                    }
                }
            } catch {
                print("DEBUG \(NetworkResponse.noJSON): \(error)")
            }
        }.resume()
    }
}
