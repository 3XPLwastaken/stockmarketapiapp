//
//  Stock.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 3/9/26.
//

import Foundation
import SwiftData

//@Model
struct Stock: Identifiable, Codable {
    var name: String = ""
    var lots: [ShareLot] = []
    var id: UUID = UUID()

    init(name: String, lots: [ShareLot] = []) {
        self.name = name
        self.lots = lots
    }

    func getCurrentPrice() async -> Double {
        return await FinnhubAPI.getCurrentStockPrice(name: name)
    }

    static func getPrice(name: String) async -> Double {
        return await FinnhubAPI.getCurrentStockPrice(name: name)
    }
}
