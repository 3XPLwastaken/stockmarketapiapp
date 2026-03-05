//
//  Finnhub.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 2/23/26.
//

import SwiftUI
import Combine
import Foundation


struct AlpacaAPI {
    static let API_SECRET_KEY = "BYw2cLRMZ7X4Wx3pc12tsQaqDr5aDYWcVTiNmgLWYXi9" // pls get pls
    static let API_KEY = "PKQZJFYTR4FDIRGVZ25F44IOFV"
    
    // cached so that we dont send too nany requewsts too fast since we use a free api
    static var cached : [(String) : (JSONValue, Double)] = [:]
    
    // ??
    static func requestStockHistory(name : String, time: String?) async -> JSONValue { //ImplicitJSON
        let cacheKey = name + " " + (time ?? "_def")
        if cached[cacheKey] != nil {
            // less than a minute old so its okay this data is up to date enough
            if (cached[cacheKey]?.1 ?? 0) < (Date.now.timeIntervalSince1970 + 60) {
                return cached[cacheKey]!.0
            }
        }
        
        // https://data.alpaca.markets/v2/stocks/bars?limit=1000&adjustment=raw&feed=sip&sort=as
        
        let sessionURL = URL(string: "https://data.alpaca.markets/v2/stocks/bars?symbols=" + name + "&timeframe=" + (time ?? "1hr") + "&limit=1000&adjustment=raw&feed=sip&sort=asc")!
        
        var request = URLRequest(url: sessionURL)
        request.httpMethod = "GET"
        
        request.setValue(API_KEY, forHTTPHeaderField: "APCA-API-KEY-ID")
        request.setValue(API_SECRET_KEY, forHTTPHeaderField: "APCA-API-SECRET-KEY")
        
        // not sure if this is required wiht swiftui or is implied but im adding it sinceits in the docs
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
                
            //print(String(data: data, encoding: .utf8)!)
            
            let json = ImplicitJSON(json: String(data: data, encoding: .utf8)!)
            print(json.json)
            
            cached[name + " " + (time ?? "_def")] = (json.index(key: "bars"), Date.now.timeIntervalSince1970) as? (JSONValue, Double)
            
            return json.index(key: "bars").index(key: name.uppercased())
        } catch {
            return JSONValue(value: """
failed : true
""")
        }
    }
    
    
}

