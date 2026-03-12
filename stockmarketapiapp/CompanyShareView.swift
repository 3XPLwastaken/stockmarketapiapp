//
//  CompanyShareView.swift
//  stockmarketapiapp
//
//  Created by NIKLAS THORSEN on 3/12/26.
//

import SwiftUI

struct CompanyShareView: View {
    
    var screenSize = UIScreen.main.bounds
    
    @State var isLoading: Bool = true
    @State var stockPrices: [UUID: Double] = [:]       // current price per stock
    @State var totalValue: Double = 0.0
    @State var totalInvested: Double = 0.0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: HEADER
                // MARK: HEADER
                // MARK: HEADER
                
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
                    
                    // MARK: TOTAL VALUE + GAIN/LOSS
                    // MARK: TOTAL VALUE + GAIN/LOSS
                    // MARK: TOTAL VALUE + GAIN/LOSS
                    
                    HStack(alignment: .lastTextBaseline, spacing: 12) {
                        Text(String(format: "$%.2f", totalValue))
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
                    
                    // MARK: TAGS — cash balance + stock count
                    // MARK: TAGS — cash balance + stock count
                    // MARK: TAGS — cash balance + stock count
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Tag(title: "Cash", text: String(format: "$%.2f", Wallet.money))
                            Tag(title: "Positions", text: "\(Wallet.ownedStocks.count)")
                            Tag(title: "Currency", text: Wallet.moneyType)
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: STOCK CARDS
                    // MARK: STOCK CARDS
                    // MARK: STOCK CARDS
                    
                    LazyVStack(spacing: 12) {
                        ForEach(Wallet.ownedStocks) { stock in
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
        
        // fetch current price for every owned stock concurrently
        await withTaskGroup(of: (UUID, Double).self) { group in
            for stock in Wallet.ownedStocks {
                group.addTask {
                    let price = await stock.getCurrentPrice()
                    return (stock.id, price)
                }
            }
            for await (id, price) in group {
                stockPrices[id] = price
            }
        }
        
        // total shares value
        totalValue = Wallet.ownedStocks.reduce(0.0) { result, stock in
            let shares = stock.ownedShares.reduce(0.0) { $0 + $1.0 }
            return result + shares * (stockPrices[stock.id] ?? 0.0)
        }
        
        // total amount originally invested (price bought * shares)
        totalInvested = Wallet.ownedStocks.reduce(0.0) { result, stock in
            return result + stock.ownedShares.reduce(0.0) { $0 + $1.0 * $1.1 }
        }
        
        isLoading = false
    }
}


// MARK: - Individual Stock Card
// MARK: - Individual Stock Card
// MARK: - Individual Stock Card

struct StockShareCard: View {
    var stock: Stock
    var currentPrice: Double
    
    var screenSize = UIScreen.main.bounds
    
    var totalShares: Double {
        stock.ownedShares.reduce(0.0) { $0 + $1.0 }
    }
    
    var totalCurrentValue: Double {
        totalShares * currentPrice
    }
    
    // average price paid per share
    var avgBuyPrice: Double {
        guard !stock.ownedShares.isEmpty else { return 0 }
        let totalPaid = stock.ownedShares.reduce(0.0) { $0 + $1.0 * $1.1 }
        return totalPaid / totalShares
    }
    
    var gain: Double {
        totalCurrentValue - stock.ownedShares.reduce(0.0) { $0 + $1.0 * $1.1 }
    }
    
    var isPositive: Bool { gain >= 0 }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: TOP ROW — name + current value
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
            
            // MARK: MINI GRAPH
            RoundedRectangle(cornerRadius: 12)
                .frame(width: screenSize.width - 64, height: 70)
                .overlay {
                    Graph(name: stock.name)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .foregroundStyle(.gray.opacity(0.2))
            
            // MARK: BOTTOM TAGS — price info
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Tag(title: "Price", text: String(format: "$%.2f", currentPrice))
                    Tag(title: "Avg Buy", text: String(format: "$%.2f", avgBuyPrice))
                    Tag(title: "Lots", text: "\(stock.ownedShares.count)")
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
