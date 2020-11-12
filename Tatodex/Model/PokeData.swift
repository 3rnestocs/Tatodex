//
//  PokeData.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import UIKit

// MARK: - Pokemons
struct Pokemon: Codable {
    var results: [Species]?
    var abilities: [Ability]?
    var height, weight: Int?
    var imageURL: String?
    var image: Data?
    var description: String?
    var evolutionChain: [EvolutionChain]?
    var id, attack, defense: Int?
    var name, type: String?
    var skillName: String?
    
    init(id: Int, dictionary: [String: AnyObject]) {
        
        self.id = id
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        if let skillName = dictionary["skillName"] as? String {
            self.skillName = skillName
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageURL = imageUrl
        }
        
        if let description = dictionary["description"] as? String {
            self.description = description
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
        
        if let type = dictionary["type"] as? String {
            self.type = type.capitalized
        }
    }
}

// MARK: - Ability
struct Ability: Codable {
    let ability: Species?
}

// MARK: - Species
struct Species: Codable {
    let name: String?
    let url: String?
}

// MARK: - EvolutionChain
struct EvolutionChain: Codable {
    let id, name: String?
}
