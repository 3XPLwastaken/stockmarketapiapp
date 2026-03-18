//
//  ShareLot.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 3/13/26.
//


// we cant store our old tuple i tink
import Foundation
import SwiftData

//@Model
class ShareLot: Identifiable, Codable {
    var amount: Double
    var purchasedAt: Double

    init(amount: Double, purchasedAt: Double) {
        self.amount = amount
        self.purchasedAt = purchasedAt
    }
}


