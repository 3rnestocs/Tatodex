//  Service.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import Alamofire

class Service: Codable {

    var mainAPI = "https://pokeapi.co/api/v2/pokemon"
//    https://pokeapi.co/api/v2/pokemon/?limit=20&offset=20 This one works
//    https://pokeapi.co/api/v2/pokemon/?offset=40&limit=20
//    This one works too, this is the format I need to follow
    // MARK: - MainAPI call
    func fetchFirstPokes(pagination: Bool = false,
                    handler: @escaping (Result<[Pokemon], Error>, String) -> Void) {
        
        var originalPokes = [Pokemon]()
        
        self.callAnyEndpoint(endpoint: mainAPI) { (next, urls) in
            
            self.getAnyPokes(pokesUrls: urls) { (result) in
                switch result {
                case .success(let pokemon):
                    
                    originalPokes.append(pokemon)
                    originalPokes.sort { (poke1, poke2) -> Bool in
                        return poke1.id! < poke2.id!
                    }
                    
                    handler(.success(originalPokes), next)
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getMorePokes(url: String,
                      handler: @escaping(Result<[Pokemon], Error>) -> Void) {
        
        var morePokes = [Pokemon]()
        
        self.callAnyEndpoint(endpoint: url) { (next, urls) in
            self.getAnyPokes(pokesUrls: urls) { (result) in
                switch result {
                case .success(let pokemon):
                    
                    morePokes.append(pokemon)
                    morePokes.sort { (poke1, poke2) -> Bool in
                        return poke1.id! < poke2.id!
                    }
                    
                    handler(.success(morePokes))
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func callAnyEndpoint(endpoint: String, handler: @escaping(String, [String]) -> Void) {
        AF.request(endpoint).validate().responseResource { (response) in
            
            do {
                guard let resource = response.value else { return }
                
                guard let results = resource.results,
                      let nextUrl = resource.next,
                      let count   = resource.count,
                      let urls    = results.compactMap({$0.url!}) as [String]?
                else { return }
                
//                Previous url: \(resource.previous)
                print("""
                    Current count: \(count)
                    Next url: \(nextUrl)
                    Data obtained: \(results.count) pokemons successfully
                    """)
                
                handler(nextUrl, urls)
            } catch {
                print("DEBUG \(NetworkResponse.badRequest): \(error)")
            }
        }
    }
    
    func getAnyPokes(pokesUrls: [String],
                     handler: @escaping(Result<Pokemon, Error>) -> Void) {

        for url in pokesUrls {
            AF.request(url).validate().responsePokemon { (pokeData) in
                guard let pokes = pokeData.value else { return }

                handler(.success(pokes))
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
