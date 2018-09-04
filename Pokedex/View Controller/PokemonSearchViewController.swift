//
//  PokemonSearchViewController.swift
//  Pokedex
//
//  Created by John Tate on 9/4/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit

class PokemonSearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        setUpUi()
    }

    func setUpUi() {
        view.addVerticalGradientLayer(topColor: #colorLiteral(red: 0.9850432916, green: 0.9994240403, blue: 0.4141118905, alpha: 1), bottomColor: #colorLiteral(red: 1, green: 0.6162073065, blue: 0.3031135609, alpha: 1))
        pokemonImageView.layer.borderColor = UIColor.blue.cgColor
        pokemonImageView.layer.borderWidth = 1.5
        pokemonImageView.layer.cornerRadius = 5
        pokemonImageView.layer.shadowOffset = CGSize(width: 3, height: 4)
        pokemonImageView.layer.shadowColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        pokemonImageView.layer.shadowRadius = 3
        pokemonImageView.layer.shadowOpacity = 1 
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let pokemonText = searchBar.text?.lowercased() else { return }
        PokemonController.shared.fetchPokemon(by: pokemonText) { (pokemon) in
            guard let unwrappedPokemon = pokemon else { self.presentAlert(); return }
            DispatchQueue.main.async {
                self.nameLabel.text = unwrappedPokemon.name
                self.idLabel.text = "\(String(describing: unwrappedPokemon.id))"
                self.abilitiesLabel.text = "Abilities: \(unwrappedPokemon.abilitiesName.joined(separator: ", "))"
            }
            PokemonController.shared.fetchImage(pokemon: unwrappedPokemon, completion: { (image) in
                if image != nil {
                    DispatchQueue.main.async {
                        self.pokemonImageView.image = image
                    }
                } else {
                    self.presentAlert()
                }
            })
        }
        
        // dismisses the keyboard
        searchBar.resignFirstResponder()
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "This poke doesn't have an image", message: "Awwww ☹️", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
}
