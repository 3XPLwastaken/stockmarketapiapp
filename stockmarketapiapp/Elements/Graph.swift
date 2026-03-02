import SwiftUI


struct Candle: Identifiable {
    var id: UUID = UUID()
    
    var close:          [Double] = []
    var high:           [Double] = []
    var low:            [Double] = []
    var open:           [Double] = []
    var timestampEpoch: [String] = []
    var volume:         [Double] = []
    
    // awesome
    func minFun() -> Double { return low.min() ?? 0 }
    func maxFun() -> Double { return high.max() ?? 0 }
    
    // make a new candle collection and send it here
    static func fromJSON(_ arr: JSONValue) -> Candle {
        var candle = Candle()
        
        if let array = arr.getValue() as? NSArray {
            for item in array {
                if let dict = item as? NSDictionary {
                    candle.close.append(  Double("\(dict["c"] ?? 0)") ?? 0 )
                    candle.high.append(   Double("\(dict["h"] ?? 0)") ?? 0 )
                    candle.low.append(    Double("\(dict["l"] ?? 0)") ?? 0 )
                    candle.open.append(   Double("\(dict["o"] ?? 0)") ?? 0 )
                    candle.volume.append( Double("\(dict["v"] ?? 0)") ?? 0 )
                    candle.timestampEpoch.append( "\(dict["t"] ?? "")" )
                }
            }
        }
        
        return candle
    }
}



struct CandleView: View {
    var idx: Int = 0
    var candle: Candle
    var highest: Double
    var lowest: Double
    
    var body: some View {
        GeometryReader { geometry in
            let range = highest - lowest
            let h = geometry.size.height
            let w = geometry.size.width

            // full wick
            let wickTop    = CGFloat((highest - candle.high[idx]) / range) * h
            let wickBottom = CGFloat((highest - candle.low[idx])  / range) * h
            let wickHeight = wickBottom - wickTop

            // body
            let bodyTop    = CGFloat((highest - max(candle.open[idx], candle.close[idx])) / range) * h
            let bodyBottom = CGFloat((highest - min(candle.open[idx], candle.close[idx])) / range) * h
            let bodyHeight = max(bodyBottom - bodyTop, 1)

            let isGreen = candle.close[idx] >= candle.open[idx]

            let bodyWidth = CGFloat( max(
                Double(geometry.size.width) / Double(candle.high.count),
                1.0
            ))
            
            // wick
            Rectangle()
                .foregroundStyle(.white.opacity(bodyWidth < 1 ? 0.6 : 0.2))
                .frame(
                    width: bodyWidth < 1 ? 1 : 2,
                    height: wickHeight
                )
                .position(
                    x: w / 2,
                    y: wickTop + wickHeight / 2
                )
                .zIndex(1) // always hide behind the body
            
            // body
            Rectangle()
                .foregroundStyle(isGreen ? .green : .red)
                .frame(
                    width: bodyWidth,
                    height: bodyHeight
                )
                .position(
                    x: w / 2,
                    y: bodyTop + bodyHeight / 2
                )
                .zIndex(2)
        }
    }
}


struct Graph: View {
    var name: String = "AAPL"
    @State var candle: Candle = Candle()

    var body: some View {
        let highest = candle.maxFun()
        let lowest  = candle.minFun()
        let count   = candle.high.count
        
        if candle.high.count == 0 {
            ProgressView()
        }
        
        GeometryReader { geometry in
            let slotWidth = geometry.size.width / CGFloat(count)
            
            ForEach(0..<count, id: \.self) { i in
                CandleView(idx: i, candle: candle, highest: highest, lowest: lowest)
                    .frame(width: slotWidth, height: geometry.size.height)
                    .position(x: slotWidth * CGFloat(i) + slotWidth / 2,
                              y: geometry.size.height / 2)
            }
        }
        .task {
            print("gett data")
            
            let jsonData = await AlpacaAPI.requestStockHistory(name: name, time: "5Min")
            candle = Candle.fromJSON(jsonData)
            
            print(jsonData.value)
            
            print("candle count: \(candle.high.count)")
        }
    }
}

#Preview {
    ZStack {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.gray)
            .frame(width: 230, height: 150)
        
        Graph(name: "AAPL")
            .frame(width: 230, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
