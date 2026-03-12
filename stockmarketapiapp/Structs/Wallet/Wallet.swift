//
//  Wallet.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 3/9/26.
//

import SwiftUI


struct Wallet {
    public static var money = 2000.0
    public static var moneyType = "USD" // probably will never be used ngl
    
    public static var ownedStocks : [Stock] = []
    
    public static func createInfo() async {
        await Wallet.buyStock(stockName: "AAPL", amount: 0.87)
        await Wallet.buyStock(stockName: "ABVE", amount: 0.20)
        await Wallet.buyStock(stockName: "RBLX", amount: 8.20)
        
        print("MONEY: \(money)")
    }
    
    public static func buyStock(stockName: String, amount: Double) async -> Bool {
        let price = await Stock.getPrice(name: stockName)
        let cost = price * amount
        
        guard money >= cost else {
            print("Not enough money to buy \(stockName)")
            return false
        }
        
        money -= cost
        
        // Merge into existing position if we already own this stock
        if let i = ownedStocks.firstIndex(where: { $0.name == stockName }) {
            ownedStocks[i].ownedShares.append((amount, Date.now.timeIntervalSince1970))
        } else {
            let stock = Stock(name: stockName, ownedShares: [(amount, Date.now.timeIntervalSince1970)])
            ownedStocks.append(stock)
        }
        
        return true
    }

    public static func sellStock(id: UUID, shares: Double) async -> Bool {
        guard let i = ownedStocks.firstIndex(where: { $0.id == id }) else {
            return false
        }
        
        let totalOwned = ownedStocks[i].ownedShares.reduce(0) { $0 + $1.0 }
        
        guard shares <= totalOwned else {
            print("Can't sell more shares than owned")
            return false
        }
        
        let price = await ownedStocks[i].getCurrentPrice()
        money += price * shares
        
        if shares == totalOwned {
            // Selling entire position
            ownedStocks.remove(at: i)
        } else {
            // Partial sell — reduce shares from oldest purchases first (FIFO)
            var toRemove = shares
            while toRemove > 0 && !ownedStocks[i].ownedShares.isEmpty {
                let lot = ownedStocks[i].ownedShares[0].0
                if lot <= toRemove {
                    ownedStocks[i].ownedShares.removeFirst()
                    toRemove -= lot
                } else {
                    ownedStocks[i].ownedShares[0].0 -= toRemove
                    toRemove = 0
                }
            }
        }
        
        return true
    }
}
