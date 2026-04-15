//
//  FavoriteView.swift
//  Currency App
//
//  Created by MYKHAILO NAUMOV on 3/10/26.
//

import SwiftUI

struct FavoriteView: View {
    
    @Binding var favorites: [String]
    @Binding var selectedCountryCode: String
    
    var body: some View {
        NavigationView {
            
            List(favorites, id: \.self) { code in
                
                HStack {
                    
                    // select the country
                    Button {
                        selectedCountryCode = code
                    }
                    label: {
                        Text(countriesDict[code] ?? code)
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    // remove from favorites
                    Button {
                        if let index = favorites.firstIndex(of: code) {
                            favorites.remove(at: index)
                        }
                    } label: {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                    .buttonStyle(.borderless)
                    
                }
            }
            .navigationTitle("Favorites")
        }
        
        // load favorites when view opens
        .onAppear {
            loadFavorites()
        }
        
        // save favorites whenever changed
        .onChange(of: favorites) {
            saveFavorites()
        }
    }
    
    
    func saveFavorites() {
        UserDefaults.standard.set(favorites, forKey: "favoriteCountries")
    }
    
    
    func loadFavorites() {
        if let saved = UserDefaults.standard.stringArray(forKey: "favoriteCountries") {
            favorites = saved
        }
    }
}
