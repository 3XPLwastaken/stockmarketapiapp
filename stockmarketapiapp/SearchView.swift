//
//  SearchView.swift
//  stockmarketapiapp
//
//  Created by NIKLAS THORSEN on 2/25/26.
//

import SwiftUI

struct SearchView: View {
    @State var searchText: String = ""
    @State var results: [(name: String, symbol: String)] = []
    @State var isLoading: Bool = false
    
    @State private var size = UIScreen.main.bounds
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // MARK: - Results List
                // MARK: - Results List
                // MARK: - Results List
                
                List {
                    
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    
                    ForEach(results, id: \.symbol) { company in
                        NavigationLink(
                            destination: CompanyOverviewView(
                                companyName: company.name,
                                companySymbol: company.symbol
                            )
                        ) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(company.name)
                                        .font(.system(size: 16))
                                        .bold()
                                        .monospaced()
                                    
                                    Text(company.symbol)
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.gray.opacity(0.15))
                                        .frame(width: 80, height: 50)
                                    
                                    Graph(name: company.symbol)
                                        .frame(width: 80, height: 50)
                                }
                            }
                            .padding(.vertical, 0)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                
                // MARK: Search Bar
                // MARK: Search Bar
                // MARK: Search Bar
                // MARK: Search Bar
                
                VStack {
                    Spacer()
                    
                    HStack {
                        TextField("Search...", text: $searchText)
                            .padding()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .glassEffect(.regular.interactive())
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .onSubmit {
                                Task { await search() }
                            }
                        
                        Button {
                            Task { await search() }
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .frame(width: 55, height: 55)
                                .glassEffect(.regular.interactive())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .foregroundStyle(.black)
                        }
                    }
                    .padding()
                    .padding(.bottom, -25)
                }
            }
            .ignoresSafeArea(.keyboard)
            .background(Color.clear)
        }
    }

    private func search() async {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        isLoading = true
        results.removeAll()
        
        let s = await FinnhubAPI.searchStockName(name: searchText)
        let resultValue = s.index(key: "result")

        if let resultArray = resultValue.requestValue() as? [NSDictionary] {
            for item in resultArray {
                let description = item["description"] as? String ?? "Unknown"
                let symbol = item["symbol"] as? String ?? ""
                results.append((name: description, symbol: symbol))
            }
        }

        isLoading = false
    }
}
#Preview {
    SearchView()
}
