//
//  CompanyOverviewView.swift
//  stockmarketapiapp
//
//  Created by NIKLAS THORSEN on 2/27/26.
//

import SwiftUI
import UniformTypeIdentifiers // https://stackoverflow.com/questions/61772282/swiftui-how-to-copy-text-to-clipboard

struct CompanyOverviewView: View {
    
    let companyName: String
    let companySymbol: String
    var screenSize = UIScreen.main.bounds
    
    
    @State var price: Double? = nil
    @State var changePercent: Double? = nil
    
    // might not load
    @State var companyDescription: String = ""
    @State var companyCurrency: String = ""
    @State var companyCountry: String = ""
    @State var companyCurrencyEstimate: String = ""
    @State var companyExchange: String = ""
    
    @State var newsList: [(title: String, description: String, author: String)] = []
    
    @State var isLoading: Bool = true
    
    @StateObject private var wallet = Wallet.shared

    @State var showBuyAlert = false
    @State var showBuyResultAlert = false
    @State var buySharesInput = ""
    @State var buyResultMessage = ""
    
    @State var showSellAlert = false
    @State var showSellResultAlert = false
    @State var sellSharesInput = ""
    @State var sellResultMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text(companyName)
                        .font(.title)
                        .bold()
                    Text(companySymbol)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .monospaced()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                if isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .padding(.top, 40)
                } else {
                    
                    // MARK: TOP!!! NAME, MONEY, %
                    // MARK: TOP!!! NAME, MONEY, %
                    // MARK: TOP!!! NAME, MONEY, %
                    
                    HStack(alignment: .lastTextBaseline, spacing: 12) {
                        if let price {
                            Text(String(format: "$%.2f", price))
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                        }
                        
                        if let changePercent {
                            let isPositive = changePercent >= 0
                            Label(
                                String(format: "%@%.2f%%", isPositive ? "+" : "", changePercent),
                                systemImage: isPositive ? "arrow.up.right" : "arrow.down.right"
                            )
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(isPositive ? Color.green : Color.red)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                (isPositive ? Color.green : Color.red).opacity(0.15),
                                in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    /*if !companyDescription.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Text(companyDescription)
                                .font(.body)
                                .lineSpacing(4)
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .padding(.horizontal)
                    }*/
                    
                    // MARK: TAGS!!!!
                    // MARK: TAGS!!!!
                    // MARK: TAGS!!!!
                    
                    ScrollView {
                        HStack {
                            if !companyDescription.isEmpty {
                                Tag(title: "About", text: companyDescription)
                            }
                            
                            if !companyCurrency.isEmpty && !companyCurrencyEstimate.isEmpty {
                                // stock is in a different currency maybe? so show that currency and what you're viewing it in now (converted)
                                // im not really too sure why there is a distinction between these two but ill add it because it must be important
                                if companyCurrency != companyCurrencyEstimate {
                                    Tag(title: "Currency", text: companyCurrencyEstimate + " (" + companyCurrency + ")")
                                
                                // company is in this currency
                                } else {
                                    Tag(title: "Currency", text: companyCurrency)
                                }
                            }
                            
                            if !companyExchange.isEmpty {
                                Tag(title: "Exchange", text: companyExchange)
                            }
                            if !companyCountry.isEmpty {
                                Tag(title: "Country", text: companyCountry)
                            }
                        }
                    }
                    
                }
                
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: 30)
                    .overlay {
                        Graph(name: companySymbol)
                    }
                    .foregroundStyle(.opacity(0))
                    .padding(.bottom, 5)
                
                HStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: UIScreen.main.bounds.width - 25, height: UIScreen.main.bounds.width - 150)
                        .overlay {
                            Graph(name: companySymbol)
                        }
                        .foregroundStyle(
                            .gray.opacity(0.25)
                        )
                    
                    Spacer()
                }
                
                // MARK: BUY SELL OTHER BUTTONS
                // MARK: BUY SELL OTHER BUTTONS
                // MARK: BUY SELL OTHER BUTTONS
                
                
                HStack {
                    Spacer()
                    
                    Button("Buy") {
                        buySharesInput = ""
                        showBuyAlert = true
                    }
                    .bold()
                    .frame(width: screenSize.width/2 - 15)
                    .padding(.vertical, 14)
                    .glassEffect(.regular.interactive().tint(.green))
                    .foregroundStyle(.white)
                    .buttonStyle(.plain)
                    
                    Button("Sell") {
                        sellSharesInput = ""
                        showSellAlert = true
                    }
                    .bold()
                    .frame(width: screenSize.width/2 - 15)
                    .padding(.vertical, 14)
                    .glassEffect(.regular.interactive().tint(.green.mix(with: .gray, by: 0.5)))
                    .foregroundStyle(.white)
                    .buttonStyle(.plain)
                    
                    
                    
                    Spacer()
                }.padding(.top, 10)
                
                
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(newsList, id: \.title) { article in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(article.title)
                                    .font(.headline)
                                    .lineLimit(2)
                                Text(article.author)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(article.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(3)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .glassEffect(
                                .regular.interactive().tint(.gray.opacity(0.2)),
                                in: RoundedRectangle(cornerRadius: 16)
                            )
                            //.tint(.gray)
                            .onTapGesture {
                                // copy url to clipboard
                                // not tested
                                
                                //https://stackoverflow.com/questions/61772282/swiftui-how-to-copy-text-to-clipboard
                                //UIPasteboard.general.string = ""
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                
            }
            .padding(.top, 16)
        }
        .navigationTitle(companySymbol)
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadData() }
        
        // MARK: BUY SHARES!!!
        // MARK: BUY SHARES!!!
        // MARK: BUY SHARES!!!
        // MARK: BUY SHARES!!!
        // MARK: BUY SHARES!!!
        
        .alert("Buy \(companySymbol)", isPresented: $showBuyAlert) {
            TextField("Shares (e.g. 1.5)", text: $buySharesInput)
                .keyboardType(.decimalPad)
            
            Button("Buy") {
                Task {
                    let shares = Double(buySharesInput) ?? -1
                    if shares > 0 {
                        let success = await wallet.buyStock(stockName: companySymbol, amount: shares)
                        buyResultMessage = success
                            ? "Bought \(buySharesInput) shares of \(companySymbol)."
                            : "Not enough funds."
                    } else {
                        buyResultMessage = "Enter a valid number of shares."
                    }
                    showBuyResultAlert = true
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            if let price {
                Text(String(format: "Current price: $%.2f", price))
            }
        }
        .alert("Order Status", isPresented: $showBuyResultAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(buyResultMessage)
        }
        
        // MARK: SELL SHARES!!!
        // MARK: SELL SHARES!!!
        // MARK: SELL SHARES!!!
        // MARK: SELL SHARES!!
        
        .alert("Sell \(companySymbol)", isPresented: $showSellAlert) {
            TextField("Shares (e.g. 1.5)", text: $sellSharesInput)
                .keyboardType(.decimalPad)
            Button("Sell") {
                Task {
                    let shares = Double(sellSharesInput) ?? -1
                    if shares > 0 {
                        let stock = wallet.ownedStocks.first(where: { $0.name == companySymbol })
                        if let stock {
                            let success = await wallet.sellStock(id: stock.id, shares: shares)
                            sellResultMessage = success
                                ? "Sold \(sellSharesInput) shares of \(companySymbol)."
                                : "Not enough shares."
                        } else {
                            sellResultMessage = "You don't own any \(companySymbol)."
                        }
                    } else {
                        sellResultMessage = "Enter a valid number of shares."
                    }
                    showSellResultAlert = true
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            let stock = wallet.ownedStocks.first(where: { $0.name == companySymbol })
            let totalShares = stock?.lots.reduce(0.0) { $0 + $1.amount } ?? 0
            Text(String(format: "You own %.4f shares", totalShares))
        }
        .alert("Order Status", isPresented: $showSellResultAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(sellResultMessage)
        }
    }
    
    private func loadData() async {
        isLoading = true
        
        async let quoteTask: () = fetchQuote()
        async let profileTask: () = fetchProfile()
        newsList = [] // reset the data
        
        await quoteTask
        await profileTask
        
        isLoading = false
        
        var newsJSON = await NewsAPI.requestSearchResults(search: "\"\(companyName)\" \"\(companySymbol)\"" + "")
        
        if let newsArray = newsJSON.requestValue() as? [NSDictionary] {
            for item in newsArray {
                let description = item["description"] as? String ?? "Unknown"
                let title = item["title"] as? String ?? "Unknown"
                let author = item["author"] as? String ?? "None?"
                newsList.append((title: title, description: description, author: author))
                
               // print(title)
            }
        }
        
    }
    
    
    // TODO: maybe make this just use the graph data?
    private func fetchQuote() async {
        let response = await FinnhubAPI.getStockQuote(symbol: companySymbol)
        if let current = response.index(key: "c").requestValue() as? Double {
            price = current
        }
        
        if let dp = response.index(key: "dp").requestValue() as? Double {
            changePercent = dp
        }
    }

    private func fetchProfile() async {
        let response = await FinnhubAPI.getCompanyProfile(symbol: companySymbol)
        
        // hi nik
        
        companyDescription = response.index(key: "description").requestValue() as? String ?? ""
        companyCountry = response.index(key: "country").requestValue() as? String ?? ""
        companyCurrency = response.index(key: "currency").requestValue() as? String ?? ""
        companyCurrencyEstimate = response.index(key: "estimateCurrency").requestValue() as? String ?? ""
        companyExchange = response.index(key: "exchange").requestValue() as? String ?? ""
    }
    
    /*    private func fetchProfile() async {
     let response = await FinnhubAPI.getCompanyProfile(symbol: companySymbol)
     
     if let desc = response.index(key: "description").requestValue() as? String {
         companyDescription = desc
     }
 }**/
}

#Preview {
    CompanyOverviewView(companyName: "Apple", companySymbol: "AAPL")
}
