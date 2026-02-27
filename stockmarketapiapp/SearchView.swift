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

    var body: some View {
        NavigationStack {
            ZStack {
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
                        NavigationLink(destination: CompanyOverviewView(
                            companyName: company.name,
                            companySymbol: company.symbol
                        )) {
                            Text("\(company.name) (\(company.symbol))")
                                .font(.system(size: 16))
                                .bold()
                                .monospaced()
                                .foregroundStyle(.white.mix(with: .black, by: 0.6))
                                .padding(.vertical, 8)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .padding(.bottom, 120)

                VStack {
                    Spacer()

                    HStack {
                        TextField("Search...", text: $searchText)
                            .padding()
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .glassEffect(.regular.interactive())
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .onSubmit {
                                Task { await search() }
                            }

                        Button {
                            Task { await search() }
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.black.mix(with: .white, by: 0.5))
                                .frame(width: 55, height: 55)
                                .glassEffect(.regular.interactive())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                    .padding()
                    .padding(.bottom, 10)
                }
            }
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
