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
struct ShareLot: Identifiable, Codable {
    var id: UUID = UUID()
    var amount: Double
    var purchasedAt: Double
    var purchasedDate: Date = Date()

    init(amount: Double, purchasedAt: Double) {
        self.amount = amount
        self.purchasedAt = purchasedAt
        self.purchasedDate = Date()
    }
}


