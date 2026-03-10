//
//  Stock.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 3/9/26.
//

struct Stock {
    public var name : String = ""
    public var ownedShares : [(Double, Double)] = [] // (price bought for, amount)
}
