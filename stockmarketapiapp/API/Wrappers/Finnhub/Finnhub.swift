//
//  Finnhub.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 2/23/26.
//

import SwiftUI
import Combine
import Foundation


struct FinnhubAPI {
    static let API_KEY = "d6eau71r01qloir5ssrgd6eau71r01qloir5sss0"
    static func getCurrentStockPrice(name : String) -> Double {
        return 0.0
    }
    
    static func searchStocks(name: String) -> [String] {
        return []
    }
    
    static func listenForMarketChanges(marketName : String, onMessage : @escaping (_ msg : ImplicitJSON) -> Void) -> FinnhubSocket {
        return FinnhubSocket(
            url: "wss://ws.finnhub.io?token=" + API_KEY, onMessage: onMessage)
    }
    
    static func searchStockName(name : String) async -> ImplicitJSON {
        let sessionURL = URL(string: "https://finnhub.io/api/v1/search?q=" + name + "&exchange=US&token=" + API_KEY)
        
        do {
            let (data, _) = try await URLSession.shared.data(from: sessionURL!)
            let json = ImplicitJSON(json: String(data: data, encoding: .utf8)!)
            print(json)
            return json
        } catch {
            return ImplicitJSON(json: "{ \"failed\": true }")
        }
    }
    
    static func getStockQuote(symbol: String) async -> ImplicitJSON {
        guard let encodedSymbol = symbol.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://finnhub.io/api/v1/quote?symbol=\(encodedSymbol)&token=\(API_KEY)") else {
            return ImplicitJSON(json: "{ \"failed\": true }")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = ImplicitJSON(json: String(data: data, encoding: .utf8)!)
            print("Quote [\(symbol)]: \(json)")
            return json
        } catch {
            print("getStockQuote error: \(error)")
            return ImplicitJSON(json: "{ \"failed\": true }")
        }
    }
    
    static func getCompanyProfile(symbol: String) async -> ImplicitJSON {
        guard let encodedSymbol = symbol.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://finnhub.io/api/v1/stock/profile2?symbol=\(encodedSymbol)&token=\(API_KEY)") else {
            return ImplicitJSON(json: "{ \"failed\": true }")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = ImplicitJSON(json: String(data: data, encoding: .utf8)!)
            print("Profile [\(symbol)]: \(json)")
            return json
        } catch {
            print("getCompanyProfile error: \(error)")
            return ImplicitJSON(json: "{ \"failed\": true }")
        }
    }
}
