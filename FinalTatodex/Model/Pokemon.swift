//
//  PokeData.swift
//  Tatodex
//
//  Created by Ernesto Jose Contreras Lopez on 11/6/20.
//

import UIKit

// MARK: - Resource list
struct Resource: Codable {
    var count: Int?
    var next, previous: String?
    var results: [Custom]?
}

// MARK: - Pokemons
struct Pokemon: Codable {
    var results: [Custom]?
    var name: String?
    var abilities, types: [AbilityAndType]?
    var height, weight, id: Int?
    var sprites: Sprite?
    var stats: [Stat]?
    var statNum: [Int]?
    var species: Custom?
}

// MARK: - AbilityAndTypes
struct AbilityAndType: Codable {
    let ability: Custom?
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
    let description: [CustomDescription]?
    let generation: Custom?
//    let evoChain: EvolutionChain?
    
    enum CodingKeys: String, CodingKey {
        case description    = "flavor_text_entries"
//        case evoChain       = "evolution_chain"
        case generation
    }
}

struct TypesAndSkillsLanguage: Codable {
    let names: [CustomDescription]?
}

struct CustomDescription: Codable {
    let text, name: String?
    let language: Custom?
    
    enum CodingKeys: String, CodingKey {
        case text = "flavor_text"
        case language, name
    }
}
//
//struct EvolutionChain: Codable {
//    let nextEvo: Custom?
//    let id: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case nextEvo = "evolves_to"
//        case id
//    }
//}

// MARK: - Stats
struct Stat: Codable {
    let baseStat: Int?
    let stat: Custom?

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}
