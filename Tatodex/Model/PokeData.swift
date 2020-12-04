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
    var height, weight: Int?
    var sprites: Sprite?
    var id, attack, defense: Int?
    var name: String?
    var types: [Type]?
    var stats: [Stat]?
    var statNum: [Int]?
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

// MARK: - Stats
struct Stat: Codable {
    let baseStat, effort: Int?
    let stat: Custom?

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}
