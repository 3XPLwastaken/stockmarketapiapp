//
//  Stock.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 3/9/26.
//

import Foundation

struct Stock : Identifiable {
    public var id : UUID = UUID()
    
    public var name : String = ""
    public var ownedShares : [(Double, Double)] = [] // (price bought for, amount)
    
    public func getCurrentPrice() -> Double {
        return FinnhubAPI.getCurrentStockPrice(name: name)
    }
}
