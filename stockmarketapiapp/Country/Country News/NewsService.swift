//
//  NewsService.swift
//  Currency App
//
//  Created by MYKHAILO NAUMOV on 3/2/26.
//

import Foundation

class NewsService {
    
    static var newsArticles: [NSDictionary] = []
    
    func loadNews(countryCode: String) {
        
        let apiKey = "36408a4f608c48278c29bfb4469c9461"
        
        let countryName = countriesDict[countryCode] ?? ""
        let formattedName = countryName.replacingOccurrences(of: " ", with: "%20")
        
        let urlString = "https://newsapi.org/v2/everything?q=\(formattedName)%20country&sortBy=publishedAt&language=en&apiKey=\(apiKey)"
        
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            
            if let data = data {
                
                let json = try? JSONSerialization.jsonObject(with: data) as? NSDictionary
                
                if let json = json,
                   let articles = json["articles"] as? [NSDictionary] {
                    
                    NewsService.newsArticles = articles
                }
            }
        }
        
        task.resume()
    }
}
