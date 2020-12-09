//
//  PokeData.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import UIKit

// MARK: - Pokemons
struct Pokemon: Codable {
    var results: [Custom]?
    var abilities: [Ability]?
    var height, weight, id: Int?
    var sprites: Sprite?
    var name: String?
    var types: [Type]?
    var stats: [Stat]?
    var statNum: [Int]?
    var species: Custom?
}

// MARK: - Ability
struct Ability: Codable {
    let ability: Custom?
}

struct Type: Codable {
    let type: Custom?
}

struct Sprite: Codable {
    let front: String?
    let shiny: String?
    
    enum CodingKeys: String, CodingKey {
        case front  = "front_default"
        case shiny  = "front_shiny"
    }
}

// MARK: - Species
struct Custom: Codable {
    let name: String?
    let url: String?
}

struct Species: Codable {
    let description: [Description]?
    let generation: Custom?
    let evoChain: EvolutionChain?
    
    enum CodingKeys: String, CodingKey {
        case description    = "flavor_text_entries"
        case evoChain       = "evolution_chain"
        case generation
    }
}

struct Description: Codable {
    let text: String?
    let language: Custom?
    
    enum CodingKeys: String, CodingKey {
        case text = "flavor_text"
        case language
    }
}


struct EvolutionChain: Codable {
    let nextEvo: Custom?
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case nextEvo = "evolves_to"
        case id
    }
}

// MARK: - Stats
struct Stat: Codable {
    let baseStat: Int?
    let stat: Custom?

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}
