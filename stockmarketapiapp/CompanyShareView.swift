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
                            StockShareCard(
                                stock: stock,
                                currentPrice: stockPrices[stock.id] ?? 0.0
                            )
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


struct StockShareCard: View {
    var stock: Stock
    var currentPrice: Double
    
    var screenSize = UIScreen.main.bounds
    
    var totalShares: Double {
        stock.lots.reduce(0.0) { $0 + $1.amount }
    }
    
    var totalCurrentValue: Double {
        totalShares * currentPrice
    }
    
    var avgBuyPrice: Double {
        guard !stock.lots.isEmpty else { return 0 }
        let totalPaid = stock.lots.reduce(0.0) { $0 + $1.amount * $1.purchasedAt }
        return totalPaid / totalShares
    }
    
    var gain: Double {
        totalCurrentValue - stock.lots.reduce(0.0) { $0 + $1.amount * $1.purchasedAt }
    }
    
    var isPositive: Bool { gain >= 0 }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(alignment: .lastTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(stock.name)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .monospaced()
                    Text(String(format: "%.4f shares", totalShares))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "$%.2f", totalCurrentValue))
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    
                    Label(
                        String(format: "%@$%.2f", isPositive ? "+" : "", gain),
                        systemImage: isPositive ? "arrow.up.right" : "arrow.down.right"
                    )
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(isPositive ? Color.green : Color.red)
                }
            }
            
            RoundedRectangle(cornerRadius: 12)
                .frame(width: screenSize.width - 64, height: 70)
                .overlay {
                    Graph(name: stock.name)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .foregroundStyle(.gray.opacity(0.2))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Tag(title: "Price",   text: String(format: "$%.2f", currentPrice))
                    Tag(title: "Avg Buy", text: String(format: "$%.2f", avgBuyPrice))
                    Tag(title: "Lots",    text: "\(stock.lots.count)")
                }
            }
        }
        .padding(16)
        .glassEffect(
            .regular.interactive().tint(.gray.opacity(0.2)),
            in: RoundedRectangle(cornerRadius: 16)
        )
    }
}


#Preview {
    CompanyShareView()
}
