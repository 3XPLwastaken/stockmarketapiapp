//
//  Wallet.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 3/9/26.
//

import SwiftUI
import Combine

class Wallet: ObservableObject {
    static let shared = Wallet()

    // this is really cool
    // didSet runs whenever the value changes, so it autosaves when the value is changes
    @Published var money: Double { didSet { save() } }
    @Published var ownedStocks: [Stock] { didSet { save() } }
    
    var moneyType: String = "USD" // this is never used

    private init() {
        let savedMoney = UserDefaults.standard.double(forKey: "wallet_money")
        self.money = savedMoney == 0 ? 2000.0 : savedMoney

        if let data = UserDefaults.standard.data(forKey: "wallet_stocks"),
           let decoded = try? JSONDecoder().decode([Stock].self, from: data) {
            self.ownedStocks = decoded
        } else {
            self.ownedStocks = []
        }
    }

    private func save() {
        UserDefaults.standard.set(money, forKey: "wallet_money")
        if let encoded = try? JSONEncoder().encode(ownedStocks) {
            UserDefaults.standard.set(encoded, forKey: "wallet_stocks")
        }
    }

    func buyStock(stockName: String, amount: Double) async -> Bool {
        let price = await Stock.getPrice(name: stockName)
        let cost = price * amount

        // ur broke
        if money < cost { return false }
        money -= cost

        // merge into existing position or create new one
        if let i = ownedStocks.firstIndex(where: { $0.name == stockName }) {
            ownedStocks[i].lots.append(ShareLot(amount: amount, purchasedAt: price))
        } else {
            ownedStocks.append(Stock(name: stockName, lots: [ShareLot(amount: amount, purchasedAt: price)]))
        }

        return true
    }

    func sellStock(id: UUID, shares: Double) async -> Bool {
        if let i = ownedStocks.firstIndex(where: { $0.id == id }) {
            var totalOwned = 0.0
            for lot in ownedStocks[i].lots {
                totalOwned += lot.amount
            }
            
            if shares > totalOwned {
                return false
            }

            money += await ownedStocks[i].getCurrentPrice() * shares

            // selling everything? just remove the whole position
            if shares == totalOwned {
                ownedStocks.remove(at: i)
                return true
            }

            // partial sell, eat through lots oldest first its a stack basically
            var toRemove = shares
            for lot in ownedStocks[i].lots.sorted(by: {
                $0.purchasedAt < $1.purchasedAt
            }) {
                if toRemove <= 0 { break }
                if lot.amount <= toRemove {
                    toRemove -= lot.amount
                    ownedStocks[i].lots.removeAll { $0.id == lot.id }
                } else {
                    if let j = ownedStocks[i].lots.firstIndex(where: { $0.id == lot.id }) {
                        ownedStocks[i].lots[j].amount -= toRemove
                    }
                    toRemove = 0
                }
            }

            return true
        }

        return false
    }
}
