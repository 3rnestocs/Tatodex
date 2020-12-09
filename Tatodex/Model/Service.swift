//
//  Service.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import Alamofire

class Service: Codable {
    
    var mainAPI = "https://pokeapi.co/api/v2/pokemon?limit=800"
    
    // MARK: - MainAPI call
    func fetchPokes(handler: @escaping (Pokemon) -> Void) {
        
        AF.request(mainAPI).validate().responsePokemon { (response) in
            
            let data = response.value
            guard let results = data?.results else { return }
            
            print("You've got \(results.count) pokemons successfully")
            
            for poke in results {
                
                guard let pokeUrl = poke.url else { return }
                
                AF.request(pokeUrl).validate().responsePokemon { (pokes) in
                    
                    guard let pokeData = pokes.value else { return }
                    
                    handler(pokeData)
                    
                }
            }
        }.resume()
    }
    
//    func getSample() {
//        let myUrl = "https://pokeapi.co/api/v2/pokemon-species/1/"
//
//        AF.request(myUrl).validate().responseSpecies { (response) in
//            guard let data = response.value else { return }
//
//            print(data)
//        }
//    }
    
    func getSpecies(url: String, handler: @escaping(String) -> Void) {
        
        AF.request(url).validate().responseSpecies { (response) in
            
            guard let data = response.value,
                  let descriptArray = data.description
            else { return }
 
            for desc in descriptArray {
                
                if desc.language?.name == "en" {
                    guard let description = desc.text!.components(separatedBy: .whitespacesAndNewlines) as? [String]? else { return }
                    let fullword = description!.joined(separator: " ")
                    
                    handler(fullword)
                    
                    /// This doesn't have an else statement because it runs all the descriptArray, and it would print a DEBUG msg for
                    /// every wrong case. This way the console remains clean.
                }
            }
        }
    }
}

// MARK: - Alamofire response handlers

extension DataRequest {

    @discardableResult
    func responsePokemon(queue: DispatchQueue? = nil, completionHandler: @escaping (AFDataResponse<Pokemon>) -> Void) -> Self {
        return responseDecodable(queue: queue ?? .main, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseSpecies(queue: DispatchQueue? = nil, completionHandler: @escaping (AFDataResponse<Species>) -> Void) -> Self {
        return responseDecodable(queue: queue ?? .main, completionHandler: completionHandler)
    }
}
