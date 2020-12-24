//  Service.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import Alamofire

//  Service.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import Alamofire

class Service {
    
    let baseUrl = "https://pokeapi.co/api/v2/pokemon"
    let limit = 20
    var offset = 0
    
    func getPokes(pageNumber: Int = 1,
                  shouldPage: Bool = true,
                  handler: @escaping ([Pokemon]) -> Void) {
        
        let originalPokes = [Pokemon]()
        let morePokemons = [Pokemon]()
        let endpoint = buildEndpoint(shouldPage: shouldPage)
        
        if  shouldPage {
                
                mainApiCall(mainList: morePokemons, endpoint: endpoint) { (result) in
                    switch result {
                    case .success(let pokemons):
                        handler(pokemons)
                    case .failure(let error):
                        print(error)
                    }
                }
        } else {
            mainApiCall(mainList: originalPokes, endpoint: endpoint) { (result) in
                switch result {
                case .success(let pokemons):
                    handler(pokemons)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func buildEndpoint(shouldPage: Bool = false) -> String {
        
        var endpoint = "\(baseUrl)/?limit=\(limit)&offset=\(offset)"
        
        if shouldPage {
            offset += limit
            endpoint = "\(baseUrl)/?limit=\(limit)&offset=\(offset)"
        }
        
        return endpoint
    }
    
    private func mainApiCall(mainList: [Pokemon], endpoint: String,
                     handler: @escaping (Result<[Pokemon], Error>) -> Void) {
        
        var originalPokes = mainList
        AF.request(endpoint).validate().responseResource { [self] (response) in
            
            do {
                guard let data = response.value,
                      let results = data.results,
                      let urls = results.compactMap({$0.url!}) as [String]? else { return }
                
                for url in urls {
                    AF.request(url).validate().responsePokemon { (result) in
                        
                        guard let pokemon = result.value else { return }
                        
                        originalPokes.append(pokemon)
                        originalPokes.sort { (poke1, poke2) -> Bool in
                            return poke1.id! < poke2.id!
                        }
              
                        if originalPokes.count == limit {
                            handler(.success(originalPokes))
                            
///                     Uncomment this line if u want to debug the pagination behavior.
///                     It'll print this out when user gets the last cell of the collectionView
//
//                            print("You've fetched \(results.count) pokemons. Your first is named \(originalPokes.first!.name!.capitalized)")
                        }
                    }
                }
            } catch {
            print(error)
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
