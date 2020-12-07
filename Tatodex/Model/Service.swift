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
            
            for url in results {
                
                guard let pokeUrl = url.url else { return }
                
                AF.request(pokeUrl).validate().responsePokemon { (pokes) in
                    
                    guard let pokeData = pokes.value else { return }

                    handler(pokeData)
                }
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
