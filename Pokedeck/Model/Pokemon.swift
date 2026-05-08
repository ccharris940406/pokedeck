//
//  Pokemon.swift
//  Pokedeck
//
//  Created by Carlos César Harris Castillo on 22/10/24.
//

import Foundation

struct Pokemon: Codable, Identifiable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let species: PokemonSpecie
    let sprites: PokemonSprites
    let stats: [StatItem]
}

struct PokemonSprites: Codable {
    let frontDefault: String
}

struct PokemonSpecie: Codable {
    let name: String
    let url: String
}

struct PokemonSpecieInfo: Codable {
    let name: String
    let color: PokemonColor
}

struct PokemonColor: Codable {
    let name: String
    let url: String
}

struct Response: Codable {
    let next: String?
    let previous: String?
    let results: [PokemonShortInf]
}

struct PokemonShortInf: Codable {
    let name: String
    let url: String
}

struct StatItem: Codable {
    let baseStat: Int
    let stat: Stat
    
    struct Stat: Codable {
        let name: String
    }
}
