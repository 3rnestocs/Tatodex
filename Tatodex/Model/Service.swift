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
    
    func getOtherPokes(handler: @escaping ([Pokemon]) -> Void) {
        
        var pokemonArray = [Pokemon]()
        
        AF.request(secondAPI).responseJSON { (response) in
   
            do {

                guard let pokeFetched = response.value as? [AnyObject] else { return }
                
                print("You have \(pokeFetched.count - 1) pokemon listed by now.")

                //  Get all the elements of the pokemon objects
                for (key, result) in pokeFetched.enumerated() {
                    if let dictionary = result as? [String: AnyObject] {
                        var pokemon = Pokemon(id: key, dictionary: dictionary)
                        
                        guard let imageURL = pokemon.imageURL else { return }
                        
                        self.fetchImages(withUrl: imageURL) { (img) in
                            
                            pokemon.image = img.pngData()

                            pokemonArray.append(pokemon)
                            
//                              Sort the pokemons on the view by id-order
                            pokemonArray.sort { (poke1, poke2) -> Bool in
                                return poke1.id! < poke2.id!
                            }
                                handler(pokemonArray)
                        }
                    }
                }
            } catch {
                print("There was an error: \(error)")
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

// MARK: - Alamofire response handlers

extension DataRequest {

    @discardableResult
    func responsePokemon(queue: DispatchQueue? = nil, completionHandler: @escaping (AFDataResponse<Pokemon>) -> Void) -> Self {
        return responseDecodable(queue: queue ?? .main, completionHandler: completionHandler)
    }
}
