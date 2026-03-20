//
//  StockShareCard.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 3/20/26.
//

import SwiftUI

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
