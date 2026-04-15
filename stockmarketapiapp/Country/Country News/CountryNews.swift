//
//  CountryNews.swift
//  Currency App
//
//  Created by MYKHAILO NAUMOV on 3/2/26.
//

import SwiftUI

struct CountryNews: View {
    
    var countryCode: String
    @State var articles: [NSDictionary] = []
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                Text("Country News")
                    .font(.largeTitle)
                    .bold()
                
                Button("Load News") {
                    loadNews()
                }
                .padding()
                .background(Color.blue.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(10)
                
                List(articles, id: \.self) { article in
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        // Had to googlefu to figure out how to put that image there
                        if let imageUrl = getImage(article) {
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(height: 180)
                            .clipped()
                            .cornerRadius(8)
                        }
                        
                        Text(getTitle(article))
                            .font(.headline)
                        
                        Text("Author: \(getAuthor(article))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(getDescription(article))
                            .font(.body)
                            .lineLimit(3)
                        
                        Text("Published: \(getDate(article))")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(getSource(article))
                            .font(.caption2)
                            .foregroundColor(.blue)
                        
                    }
                    .padding(.vertical, 5)
                }
            }
        }
    }
    
    func loadNews() {
        NewsService().loadNews(countryCode: countryCode)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.articles = NewsService.newsArticles
        }
    }
    
    func getTitle(_ article: NSDictionary) -> String {
        return article["title"] as? String ?? "No Title"
    }
    
    func getAuthor(_ article: NSDictionary) -> String {
        return article["author"] as? String ?? "Unknown"
    }
    
    func getDescription(_ article: NSDictionary) -> String {
        return article["description"] as? String ?? "No Description"
    }
    
    func getImage(_ article: NSDictionary) -> String? {
        return article["urlToImage"] as? String
    }
    
    func getDate(_ article: NSDictionary) -> String {
        return article["publishedAt"] as? String ?? "Unknown Date"
    }
    
    //gets a name of the source or "website"
    func getSource(_ article: NSDictionary) -> String {
        if let source = article["source"] as? NSDictionary {
            return source["name"] as? String ?? "Unknown Source"
        }
        return "Unknown Source"
    }
    
}
