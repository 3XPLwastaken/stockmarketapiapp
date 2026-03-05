import Foundation
import Combine

public class FinnhubSocket {
    private let urlString: String
    private var url: URL?
    private var webSocketTask: URLSessionWebSocketTask?
    private let onMessage: (_ msg: ImplicitJSON) -> Void
    private let queue = DispatchQueue(label: "FinnhubSocketQueue")
    
    init(url: String, onMessage: @escaping (_ msg: ImplicitJSON) -> Void) {
        self.urlString = url
        self.onMessage = onMessage
        self.url = URL(string: url)
    }
    
    public func connect() {
        queue.async { [weak self] in
            guard let self = self else { return }
            guard let url = self.url else { return }
            if self.webSocketTask == nil {
                let session = URLSession(configuration: .default)
                self.webSocketTask = session.webSocketTask(with: url)
                self.webSocketTask?.resume()
                self.receiveLoop()
            }
        }
    }
    
    public func disconnect() {
        queue.async { [weak self] in
            guard let self = self else { return }
            self.webSocketTask?.cancel(with: .goingAway, reason: nil)
            self.webSocketTask = nil
        }
    }
    
    public func subscribe(symbol: String) {
        let dict: [String: String] = ["type": "subscribe", "symbol": symbol]
        send(json: dict)
    }
    
    public func unsubscribe(symbol: String) {
        let dict: [String: String] = ["type": "unsubscribe", "symbol": symbol]
        send(json: dict)
    }
    
    private func send(json: [String: String]) {
        queue.async { [weak self] in
            guard let self = self else { return }
            guard let task = self.webSocketTask else { return }
            do {
                let data = try JSONSerialization.data(withJSONObject: json, options: [])
                if let string = String(data: data, encoding: .utf8) {
                    let message = URLSessionWebSocketTask.Message.string(string)
                    task.send(message) { error in
                        if let error = error {
                            print("FinnhubSocket send error: \(error)")
                        }
                    }
                }
            } catch {
                print("FinnhubSocket send JSON serialization error: \(error)")
            }
        }
    }
    
    private func receiveLoop() {
        queue.async { [weak self] in
            guard let self = self else { return }
            self.webSocketTask?.receive { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print("FinnhubSocket receive error: \(error)")
                case .success(let message):
                    var json: ImplicitJSON?
                    
                    switch message {
                    case .string(let text):
                        json = Self.decodeJSON(from: text)
                    case .data(let data):
                        if let text = String(data: data, encoding: .utf8) {
                            json = Self.decodeJSON(from: text)
                        } else {
                            json = ImplicitJSON(json: "{\"binaryLength\": \(data.count)}")
                        }
                    @unknown default:
                        json = ImplicitJSON(json: "{\"unknownMessage\": true}")
                    }
                    
                    if let json = json {
                        self.onMessage(json)
                    }
                    self.receiveLoop()
                }
            }
        }
    }
    
    private static func decodeJSON(from string: String) -> ImplicitJSON? {
        let json = ImplicitJSON(json: string)
        return json.success ? json : nil
    }
    
    deinit {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
