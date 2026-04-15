//
//  ContentView.swift
//  Currency App
//
//  Created by MYKHAILO NAUMOV on 2/18/26.
//

import SwiftUI

struct CountryViewApp: View {
    
    @State var selectedCountryCode = "US"
    @State var favorites: [String] = []
    
    var body: some View {
        TabView {
            
            SearchView2(selectedCountryCode: $selectedCountryCode, favorites: $favorites)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            CountryDetailView(countryCode: selectedCountryCode)
                .tabItem {
                    Label("Details", systemImage: "doc.text")
                }
            
            CountryNews(countryCode: selectedCountryCode)
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            FavoriteView(favorites: $favorites, selectedCountryCode: $selectedCountryCode)
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
            
        }
    }
}
