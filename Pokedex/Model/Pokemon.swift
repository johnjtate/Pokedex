//
//  Pokemon.swift
//  Pokedex
//
//  Created by John Tate on 9/4/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit

// Abilities
// Name
// ID
// Image

struct Pokemon: Decodable {
    
    let abilities: [AbilitiesDictionary]
    let name: String
    let id: Int
    let spritesDictionary: SpritesDictionary
    
    private enum CodingKeys: String, CodingKey {
        case abilities
        case name
        case id
        case spritesDictionary = "sprites"
    }
    
    var abilitiesName: [String] {
        return abilities.compactMap({$0.ability.name})
    }
    
    struct AbilitiesDictionary: Decodable {
        
        let ability: Ability
        
        struct Ability: Decodable {
            
            let name: String
        }
    }
    
}

struct SpritesDictionary: Decodable {
    
    let image: URL 
    
    // This enum is for the keys that match the JSON so we can have a better naming convention
    private enum CodingKeys: String, CodingKey {
        case image = "front_default"
    }
}


