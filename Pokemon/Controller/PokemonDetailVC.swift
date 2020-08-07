//
//  PokemonDetailVC.swift
//  Pokemon
//
//  Created by Fray Pineda on 10/5/18.
//  Copyright © 2018 Fray Pineda. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    var pokemoEvol: Pokemon!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name.capitalized
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        
        mainImg.image = img
        currentEvoImg.image = img
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        pokemon.downloadPokemonDetails{
            
         
            //Whatever we write will only be called after the network call is complete!
            
            self.updateUI()
            
        }
        
      
    }
    
    func updateUI() {
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        
        evoLbl.text = "\(pokemon.nameEvolution)"
        self.pokemon.downloadPokemonDetails2 {
            if self.pokemon.nextEvolutionId != ""{
                let imgEvo = UIImage(named: "\(self.pokemon.nextEvolutionId)")
                self.nextEvoImage.image = imgEvo
            }
        }
       
    }

  
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    

    

}
