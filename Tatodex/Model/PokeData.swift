//
//  PokeData.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import UIKit

struct Pokemon {
    
    var name: String?
    var imageUrl: String?
    var image: UIImage?
    var id: Int?
    var weight: Int?
    var height: Int?
    var defense: Int?
    var attack: Int?
    var description: String?
    var type: String?
    
    init(id: Int, dictionary: [String: AnyObject]) {
        
        self.id = id
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let weight = dictionary["weight"] as? Int {
            self.weight = weight
        }
        
        if let height = dictionary["height"] as? Int {
            self.height = height
        }
        
        if let defense = dictionary["defense"] as? Int {
            self.defense = defense
        }
        
        if let attack = dictionary["attack"] as? Int {
            self.attack = attack
        }
        
        if let description = dictionary["description"] as? String {
            self.description = description
        }
        
        if let type = dictionary["type"] as? String {
            self.type = type.capitalized
        }
    }
}

struct Pokemons: Codable {
    let results: [Pokes]?
}

struct Pokes: Codable {
    let name: String?
    let url: String?
}

struct PokePage: Codable {
    
    let abilities: [Ability]?
    let id: Int?
    
    init(abilities: [Ability], id: Int, name: String) {
        self.abilities = abilities
        self.id = id
    }
    
}

struct Ability: Codable {
    let name: String?
    let url: String?
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
