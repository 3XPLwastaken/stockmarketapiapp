//
//  CompanyShareView.swift
//  stockmarketapiapp
//
//  Created by NIKLAS THORSEN on 3/12/26.
//

import SwiftUI
import SwiftData

struct CompanyShareView: View {
    
    var screenSize = UIScreen.main.bounds
    
    @State var isLoading: Bool = true
    @State var stockPrices: [UUID: Double] = [:]
    @State var totalValue: Double = 0.0
    @State var totalInvested: Double = 0.0
    
    @StateObject private var wallet = Wallet.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("My Portfolio")
                        .font(.title)
                        .bold()
                    Text("Owned Shares")
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
                        Text(String(format: "$%.2f", totalInvested))
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                        
                        let gain = totalValue - totalInvested
                        let isPositive = gain >= 0
                        
                        Label(
                            String(format: "%@$%.2f", isPositive ? "+" : "", gain),
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
                    .padding(.horizontal)
                    
                    // yeah
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Tag(title: "Cash",      text: String(format: "$%.2f", wallet.money ?? 0))
                            Tag(title: "Positions", text: "\(wallet.ownedStocks.count ?? 0)")
                            Tag(title: "Currency",  text: wallet.moneyType ?? "USD")
                        }
                        .padding(.horizontal)
                    }
                    
                    LazyVStack(spacing: 12) {
                        ForEach(wallet.ownedStocks ?? []) { stock in
                            NavigationLink(destination: CompanyOverviewView(
                                companyName: stock.name,
                                companySymbol: stock.name
                            )) {
                                StockShareCard(
                                    stock: stock,
                                    currentPrice: stockPrices[stock.id] ?? 0.0
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, 16)
        }
        .navigationTitle("Portfolio")
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadData() }
    }
    
    private func loadData() async {
        isLoading = true
        
        await withTaskGroup(of: (UUID, Double).self) { group in
            for stock in wallet.ownedStocks {
                group.addTask {
                    let price = await stock.getCurrentPrice()
                    return await (stock.id, price)
                }
            }
            for await (id, price) in group {
                stockPrices[id] = price
            }
        }
        
        totalValue = wallet.ownedStocks.reduce(0.0) { result, stock in
            let shares = stock.lots.reduce(0.0) { $0 + $1.amount }
            return result + shares * (stockPrices[stock.id] ?? 0.0)
        }
        
        totalInvested = wallet.ownedStocks.reduce(0.0) { result, stock in
            result + stock.lots.reduce(0.0) { $0 + $1.amount * $1.purchasedAt }
        }
        
        isLoading = false
    }
}


#Preview {
    CompanyShareView()
}
