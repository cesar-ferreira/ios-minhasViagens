//
//  TravelUserDefaults.swift
//  Minhas Viagens
//
//  Created by César  Ferreira on 23/12/19.
//  Copyright © 2019 César  Ferreira. All rights reserved.
//

import UIKit

class TravelUserDefaults {
    
    let KEY: String = "KEY_TRAVEL"
    var travels: [ Dictionary<String, String> ] = []
    
    func saveTravel(travel: Dictionary<String, String>) {
        
        travels = list()
        
        travels.append( travel )
        UserDefaults.standard.set(travels , forKey: KEY)
        UserDefaults.standard.synchronize()
        
    }
    
    func list() -> [ Dictionary<String, String> ] {
        
        let result = UserDefaults.standard.object(forKey: KEY)
        
        if( result != nil ) {
            return result as! Array
        }
        
        return []
        
    }
    
    func remove(index: Int) {
        
        travels = list()
        
        travels.remove(at: index)
        UserDefaults.standard.set(travels , forKey: KEY)
        UserDefaults.standard.synchronize()

    }
}
