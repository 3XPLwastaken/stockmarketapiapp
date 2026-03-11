//
//  NewsAPI.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 3/9/26.
//

// e73141f63b0d46389668e9a87fa0af84

import SwiftUI
import Combine
import Foundation


struct NewsAPI {
    static let API_KEY = "e73141f63b0d46389668e9a87fa0af84"
    // allows "non secure" https request so we can test on mac
    private static let session = URLSession(
            configuration: .default,
            delegate: SessionDelegate(),
            delegateQueue: nil
        )
    
    /*static func getQueryDateAsTodayAndYesterday() -> (today: String, yest: String) {
        let dateAndTime = Date.now.formatted()
        var dateSplit = dateAndTime.split(separator: ",")[0].split(separator: "/")
        
        return (
            today: dateSplit[2] + "-" + dateSplit[0] + "-" + dateSplit[1]
            , yest: dateSplit[2] + "-" + dateSplit[0] + "-" + String((Int(dateSplit[1]) ?? -1) - 1)
        )
    }*/
    
    static func getQueryDateAsToday() -> String {
        let dateAndTime = Date.now.formatted()
        var dateSplit = dateAndTime.split(separator: ",")[0].split(separator: "/")
        
        return dateSplit[2] + "-" + dateSplit[0] + "-" + dateSplit[1]
    }
    
    // i dont think that there are api limits hooray
    static func requestSearchResults(search: String) async -> JSONValue {
        let sessionURL = URL(string: "https://newsapi.org/v2/everything?q=" + search + "&from=\(getQueryDateAsToday)&to=\(getQueryDateAsToday)&sortBy=popularity&apiKey=" + API_KEY)
        
        //print(getQueryDateAsToday())
        
        do {
            let (data, _) = try await session.data(from: sessionURL!)
            let json = ImplicitJSON(json: String(data: data, encoding: .utf8)!)
            
            return json.index(key: "articles")
        } catch {
            //print(error)
        }
        
        return JSONValue(value: "{ \"failed\" : true }")
    }
    
    
}



#Preview {
    ContentView()
}
