//
//  Wallet.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 3/9/26.
//

import SwiftUI


struct Wallet {
    public static var money = 1000.0
    public static var moneyType = "USD" // probably will never be used ngl
    
    public static var ownedStocks : [Stock] = []
    
    public static func buyStock(stockName: String) {
        
    }
    
    public static func sellStock(stockName: String) {
        
    }
}
