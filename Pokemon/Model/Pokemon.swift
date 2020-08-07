//
//  Pokemon.swift
//  Pokemon
//
//  Created by Fray Pineda on 10/4/18.
//  Copyright © 2018 Fray Pineda. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {

    private var _name:String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _pokemonURL: String!
    private var _nameEvolution: String!
    private var _urlPokeNombre: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    
    
    var nameEvolution: String{
        if _nameEvolution == nil{
            _nameEvolution = ""
        }
        return _nameEvolution
    }
    var description: String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    var defense: String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var attack : String {
        if _attack == nil{
            _attack = ""
        }
        return _attack
        
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil{
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    var name : String{
        return _name
    }
    
    var pokedexId: Int{
        return _pokedexId
    }
    
    init(name: String, PokedexId: Int){
        self._name = name
        self._pokedexId = PokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        
        Alamofire.request(_pokemonURL, method: .get).responseJSON {(response) in
            
            if let dict = response.result.value as? Dictionary<String, Any>{
                if let weight = dict["weight"] as? Int{
                    self._weight = "\(weight)"
                }
                
                if let height = dict["height"] as? Int{
                    self._height = "\(height)"
                }
                
                //searching evolution------------------------
                
                if let species = dict["species"] as? Dictionary<String, String>, species.count > 0{
                    if let url1 = species["url"] {
                        Alamofire.request(url1).responseJSON { (response) in
                            if let dictSpecies = response.result.value as? Dictionary<String, Any>{
                                if let evol = dictSpecies["evolution_chain"] as? Dictionary<String, String>{
                                    if let url2 = evol["url"]{
                                        Alamofire.request(url2).responseJSON { (response) in
                                            if let dictEvol = response.result.value as? Dictionary<String, Any>{
                                                if let chain = dictEvol["chain"] as? Dictionary<String, Any>, chain.count > 0
                                                {
                                                    if let evolTo1 = chain["evolves_to"] as? [Dictionary<String, Any>], evolTo1.count > 0{
                                                        if let evolTo2 = evolTo1[0]["evolves_to"] as? [Dictionary<String, Any>], evolTo2.count > 0{
                                                            if let spe = evolTo2[0]["species"] as? Dictionary<String, String>, spe.count > 0 {
                                                                if let nameEvol = spe["name"]{
                                                                    self._nameEvolution = nameEvol
                                                                }
                                                            }
                                                        
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            completed()
                                            
                                        }
                                    }
                                    
                                }
                            }
                            
                            completed()
                            
                        }
                            
                        
                    }
                    
                }
                
                
                //------------------------------------------
               if let stats = dict["stats"] as? [Dictionary<String,Any>]{
                    if let defensa = stats[3]["stat"] as? Dictionary<String, String>{
                        if  defensa["name"] == "defense"{
                            if let def = stats[3]["base_stat"] as? Int{
                                self._defense = "\(def)"
                            }
                        }
                    }
                }
                

                
                if let stats = dict["stats"] as? [Dictionary<String,Any>]{
                    if let ataque = stats[4]["stat"] as? Dictionary<String, String>{
                        if  ataque["name"] == "attack"{
                            if let atac = stats[4]["base_stat"] as? Int{
                                self._attack = "\(atac)"
                            }
                        }
                    }
                }
                
                
                if let types = dict["types"] as? [Dictionary<String, Any>] , types.count > 0{
                    if let arrayTipo = types[0]["type"] as? Dictionary<String, String>{
                        if let name = arrayTipo["name"]{
                            self._type = name.capitalized
                        }
                    }
                    if types.count > 1 {
                        for x in 1..<types.count{
                            if let tipox = types[x]["type"] as? Dictionary<String, String>, tipox.count > 0{
                                if let name = tipox["name"] {
                                    self._type! += "/\(name.capitalized)"
                                }
                            }
                        }
                    }
                    
                   
                }else {
                    self._type = ""
                
                }
            }
            
            
            
            completed()
        }
    }
    func downloadPokemonDetails2(completed: @escaping DownloadComplete){
        
    _urlPokeNombre = "\(URL_BASE)\(URL_POKEMON)\(self._nameEvolution!)"
        Alamofire.request(_urlPokeNombre).responseJSON { (response) in
            if let idEv = response.result.value as? Dictionary<String, Any>{
                if let id = idEv["id"] as? Int{
                    self._nextEvolutionId = "\(id)"
                }
            }
            
            completed()
        }
    }
}
