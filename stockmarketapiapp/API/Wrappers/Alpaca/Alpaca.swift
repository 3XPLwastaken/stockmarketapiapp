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
    
    // allows "non secure" https request so we can test on mac
    private static let session = URLSession(
            configuration: .default,
            delegate: SessionDelegate(),
            delegateQueue: nil
        )
    // ??
    
    static func requestStockHistory(name: String, time: String?) async -> JSONValue {
        let cacheKey = name + " " + (time ?? "_def")
        
        if let (cachedValue, cachedTime) = cached[cacheKey],
           (Date.now.timeIntervalSince1970 - cachedTime) < 60 {
            return cachedValue.index(key: name.uppercased())
        }
        
        let sessionURL = URL(string: "https://data.alpaca.markets/v2/stocks/bars?symbols=" + name + "&timeframe=" + (time ?? "1hr") + "&limit=1000&adjustment=raw&feed=sip&sort=asc")!
        
        var request = URLRequest(url: sessionURL)
        request.httpMethod = "GET"
        request.setValue(API_KEY, forHTTPHeaderField: "APCA-API-KEY-ID")
        request.setValue(API_SECRET_KEY, forHTTPHeaderField: "APCA-API-SECRET-KEY")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        do {
            let (data, _) = try await session.data(for: request)
            print(data)
            let json = ImplicitJSON(json: String(data: data, encoding: .utf8)!)
            print(json.json)
            
            let bars = json.index(key: "bars")
            cached[cacheKey] = (bars, Date.now.timeIntervalSince1970) // ✅ no cast needed
            
            return bars.index(key: name.uppercased())
        } catch {
            print(error.localizedDescription)
            print("FAILED TO GET DAATA")
            
            return JSONValue(value: "failed : true")
        }
    }
    
    
}

