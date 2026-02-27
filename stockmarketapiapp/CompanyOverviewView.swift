//
//  CompanyOverviewView.swift
//  stockmarketapiapp
//
//  Created by NIKLAS THORSEN on 2/27/26.
//

import SwiftUI

struct CompanyOverviewView: View {

    let companyName: String
    let companySymbol: String

    @State var price: Double? = nil
    @State var changePercent: Double? = nil

    @State var companyDescription: String = ""

    @State var isLoading: Bool = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text(companyName)
                        .font(.title)
                        .bold()
                    Text(companySymbol)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .monospaced()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                if isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .padding(.top, 40)
                } else {
                    
                    HStack(alignment: .lastTextBaseline, spacing: 12) {
                        if let price {
                            Text(String(format: "$%.2f", price))
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                        }

                        if let changePercent {
                            let isPositive = changePercent >= 0
                            Label(
                                String(format: "%@%.2f%%", isPositive ? "+" : "", changePercent),
                                systemImage: isPositive ? "arrow.up.right" : "arrow.down.right"
                            )
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(isPositive ? Color.green : Color.red)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                (isPositive ? Color.green : Color.red).opacity(0.15),
                                in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                            )
                        }
                    }
                    .padding(.horizontal)

                    if !companyDescription.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Text(companyDescription)
                                .font(.body)
                                .lineSpacing(4)
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .padding(.top, 16)
        }
        .navigationTitle(companySymbol)
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadData() }
    }

    private func loadData() async {
        isLoading = true
        async let quoteTask = fetchQuote()
        async let profileTask = fetchProfile()
        await quoteTask
        await profileTask
        isLoading = false
    }

    private func fetchQuote() async {
        let response = await FinnhubAPI.getStockQuote(symbol: companySymbol)
        if let current = response.index(key: "c").requestValue() as? Double {
            price = current
        }
        if let dp = response.index(key: "dp").requestValue() as? Double {
            changePercent = dp
        }
    }

    private func fetchProfile() async {
        let response = await FinnhubAPI.getCompanyProfile(symbol: companySymbol)
        if let desc = response.index(key: "description").requestValue() as? String {
            companyDescription = desc
        }
    }
}

#Preview {
    NavigationStack {
        CompanyOverviewView(companyName: "Apple Inc.", companySymbol: "AAPL")
    }
}
