//
//  Finnhub.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 2/23/26.
//

import SwiftUI
import Combine
import Foundation


struct FinnhubAPI {
    static let API_KEY = "d6eau71r01qloir5ssrgd6eau71r01qloir5sss0" // pls get pls
    
    static func getCurrentStockPrice(name : String) -> Double {
        return 0.0
    }
    
    static func searchStocks(name: String) -> [String] {
        return []
    }
    
    static func listenForMarketChanges(marketName : String, onMessage : @escaping (_ msg : ImplicitJSON) -> Void) -> FinnhubSocket {
        return FinnhubSocket(
            url: "wss://ws.finnhub.io?token=" + API_KEY, onMessage: onMessage)
        
    }
}


// brag

@MainActor
final class FinnhubSocket: ObservableObject {

    let WEBSOCKET: WebSocket
    let RECONNECTABLE_WEBSOCKET: ReconnectableWebSocket

    @Published var SOCKET_EVENT: WebSocket.StateChangedEvent = .connecting

    private var eventTask: Task<Void, Never>?
    private var messageTask: Task<Void, any Error>?
    
    let onMessage: (_ msg : ImplicitJSON) -> Void

    //init(marketName: String, onMessage : (_ msg : String) -> Void) {
    init(url: String, onMessage : @escaping (_ msg : ImplicitJSON) -> Void) {
        let url = URL(string: url)!

        WEBSOCKET = WebSocket(url: url)

        RECONNECTABLE_WEBSOCKET = ReconnectableWebSocket {
            URLRequest(url: url)
        }

        self.onMessage = onMessage
        startListening()
    }

    private func startListening() {

        // STATE EVENTS
        eventTask = Task { [weak self] in
            guard let self else { return }
            
            print("event task!!!")

            for await event in self.WEBSOCKET.stateEvents {
                self.SOCKET_EVENT = event
                print("EVENT!!: \(event)")
            }
        }

        // WAIT FOR CONNECTION
        messageTask = Task { [weak self] in
            guard let self else { return }

            print("MESSAGE TASK!!!")
            
            for try await message in WEBSOCKET.messages {
                print(message)
                // As String or Data
                switch message {
                case .string(let string):
                    var json = ImplicitJSON(json: string)
                    
                    onMessage(json)
                case .data:
                    print("Received data")
                case .invalid:
                    print("Received an unparsable message")
                }
            }
        }
    }

    // die
    deinit {
        eventTask?.cancel()
        messageTask?.cancel()
    }
}
