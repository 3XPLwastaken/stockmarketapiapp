//
//  CountryService.swift
//  Currency App
//
//  Created by MYKHAILO NAUMOV on 2/23/26.
//

import Foundation

class CountryService {
    
    static var countryData: NSDictionary? = nil
    
    func loadCountry(countryCode: String) {
        
        let urlString = "https://restcountries.com/v3.1/alpha/\(countryCode)"
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data) as? [NSDictionary]
                
                if let json = json, json.count > 0 {
                    CountryService.countryData = json[0]
                }
            }
        }
        
        task.resume()
    }
}
