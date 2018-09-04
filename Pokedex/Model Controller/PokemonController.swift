//
//  PokemonController.swift
//  Pokedex
//
//  Created by John Tate on 9/4/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import Foundation
import UIKit

class PokemonController {
    
    static let shared = PokemonController()
    
    // This makes it so we can't make another instance outside of this class.  It helps prevent memory leaks.
    private init() {}
    
    // MARK: - Properties
    let baseURL = URL(string: "https://pokeapi.co/api/v2")
    
    // Gives you the ability to create 2 paths when you call it
    func fetchPokemon(by pokemonName: String, completion: @escaping (Pokemon?) -> Void) {
        
        // 1) Know what you want to display (complete) to the user
        // 2) Call URLSession - so you can work backwards
        // 3) We need the base url
        guard let unwrappedBaseUrl = baseURL else {
            fatalError("bad base url")
        }
        // Use components if you want to use query items.
        //        var components = URLComponents(url: unwrappedBaseUrl, resolvingAgainstBaseURL: true)
        let requestURL = unwrappedBaseUrl.appendingPathComponent("pokemon").appendingPathComponent(pokemonName)
        // 4) Build your url - Components ("/"), Queries [:], and Extensions (".")
        
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            // 3) Do try catch
            do {
                
                // 1) Handle your error
                if let error = error { throw error }
                // 2) Handle data
                guard let data = data else { throw NSError() }
                
                // 4) JSONDecoder
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(pokemon)
                
            } catch let error {
                print("Error fetching pokemon \(error) \(error.localizedDescription)")
                completion(nil); return
            }
            
            // 5) Decode & Complete with your object
            
        }.resume()
    }
    
    func fetchImage(pokemon: Pokemon, completion: @escaping (UIImage?) -> Void) {
    
        let imageUrl = pokemon.spritesDictionary.image
        
        // DataTask is out async call.
        URLSession.shared.dataTask(with: imageUrl) { (data, _, error) in
            
            do {
                if let error = error { throw error }
                guard let data = data else { throw NSError() }
                
                // Completion nil means that it won't return anything.  As soon as it sees the key word return, it will just return.
                guard let image = UIImage(data: data) else { completion(nil); return }
                
                print("Are you on the main thread?? \(Thread.isMainThread)")
                completion(image)
            } catch let error {
                print("Error fetching image \(error) \(error.localizedDescription)")
                completion(nil); return
             }
            
        }.resume()
        
    }
    
}
