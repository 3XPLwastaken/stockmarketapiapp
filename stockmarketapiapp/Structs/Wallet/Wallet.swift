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
        var a = Stock(name: stockName, ownedShares: [(amount, Date.now.timeIntervalSince1970)])
        
        print("money for \(stockName): \(await a.getCurrentPrice() * amount)")
        
        await money -= a.getCurrentPrice() * amount
        
        return true
    }
    
    public static func sellStock(id: UUID, shares: Double) async -> Bool {
        var owned : Stock? = nil
        var i2 : Int = -1
        
        for i in 0..<ownedStocks.count {
            if ownedStocks[i].id == id {
                owned = ownedStocks[i]
                i2 = i
                break
            }
        }
        
        if owned == nil {
            return false
        }
        
        // ok its time to sell
        await money += owned!.getCurrentPrice() * shares
        ownedStocks.remove(at: i2)
        
        return true
    }
}
