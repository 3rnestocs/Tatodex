//  Service.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import Alamofire

class Service: Codable {
    
    var isPaginating = false
    var mainEndpoint = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=50"
    
    // MARK: - MainAPI call
    func fetchFirstPokes(pagination: Bool = false,
                         handler: @escaping (Result<[Pokemon], Error>) -> Void) {
        
        var originalPokes = [Pokemon]()
        var nextUrlArray = [String]()
        var morePokes = [Pokemon]()
        
        if pagination {
            self.isPaginating = true
        }
        
        self.callAnyEndpoint(endpoint: mainEndpoint) { (result, next) in
            switch result {
            case .success(let pokemon):
                originalPokes.append(pokemon)
                originalPokes.sort { (poke1, poke2) -> Bool in
                    return poke1.id! < poke2.id!
                }
                
                guard let nextUrl = next else { return }
                nextUrlArray.append(nextUrl)
                
                if nextUrlArray.count == 50 {
                    guard let nextEndpoint = nextUrlArray.first else { return }
                    
                    print("---SECOND API CALL---")
                    service.getMorePokes(nextEndpoint: nextEndpoint, morePokes: morePokes) { (result, next) in
                        switch result {
                        case .success(let pokes2):
                            
                            if pokes2.count == 50 {
                                morePokes = pokes2
                            }
                            handler(.success(pagination ? morePokes : originalPokes))
                            
                            if pagination {
                                self.isPaginating = false
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            case .failure(let error):
                print("DEBUG: \(NetworkResponse.failed), \(error)")
            }
        }
    }
    
    func callAnyEndpoint(endpoint: String,
                         handler: @escaping(Result<Pokemon, Error>, String?) -> Void) {
        AF.request(endpoint).validate().responseResource { (response) in
            
            if let error = response.error {
                handler(.failure(error), nil)
                print("DEBUG ERROR: \(NetworkResponse.noJSON)")
            }
            
            do {
                guard let resource = response.value,
                      let results  = resource.results,
                      let nextUrl  = resource.next,
                      let count    = resource.count,
                      let urls     = results.compactMap({$0.url!}) as [String]?
                else { return }
                
                    print("""
                        Current count: \(count)
                        Next url: \(nextUrl)
                        Data obtained: \(results.count) pokemons successfully
                        """)
                
                for url in urls {
                    AF.request(url).validate().responsePokemon { (pokeData) in
                        guard let pokes = pokeData.value else { return }

                       handler(.success(pokes), nextUrl)
                    }
                }
            } catch {
                print("DEBUG \(NetworkResponse.badRequest): \(error)")
            }
        }
    }
    
    func getMorePokes(nextEndpoint: String, morePokes: [Pokemon],
                     handler: @escaping(Result<[Pokemon], Error>, String?) -> Void) {
        
        var morePokemons = morePokes
        
        self.callAnyEndpoint(endpoint: nextEndpoint) { (result, next) in
            switch result {
            case .success(let pokemon2):
                morePokemons.append(pokemon2)
                morePokemons.sort { (poke1, poke2) -> Bool in
                    return poke1.id! < poke2.id!
                }                    
                    handler(.success(morePokemons), next)
            case .failure(let error):
                print("DEBUG: \(error)")
            }
        }
    }
    
    func getTypesOrSkills(url: String,
                          handler: @escaping(Result<[CustomDescription], Error>) -> Void) {
        
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
    
    func getSpecies(url: String,
                    handler: @escaping(Result<String, Error>) -> Void) {
        
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
