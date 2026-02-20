//
//  ContentView.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 2/18/26.
//

//d6asa21r01qnr27inpk0d6asa21r01qnr27inpkg

import SwiftUI

struct ContentView: View {
    var screenSize = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
           
            VStack {
                RoundedRectangle(cornerRadius: 32)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color.white.mix(with: .gray, by: 0.4), lineWidth: 4)
                            .overlay(content: {
                                
                            })
                    )
                    .overlay(content: {
                        VStack {
                            HStack {
                                Text("$2000 dollars")
                                    .foregroundStyle(.green.mix(with: .black, by: 0.1))
                                    .font(.system(size: 20))
                                    .bold()
                                    .monospaced()
                                    .padding(.all, 30.0)
                                
                                Spacer()
                                
                                Text("- $14")
                                    .foregroundStyle(.red.mix(with: .black, by: 0.1))
                                    .font(.system(size: 20))
                                    .bold()
                                    .monospaced()
                                    .padding(.all, 30.0)
                                    .multilineTextAlignment(.trailing)
                            }
                            
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.mix(with: .gray, by: 0.4), lineWidth: 4)
                                .overlay(content: {
                                    Text("Market closes in: 10 hrs")
                                        .foregroundStyle(.white.mix(with: .black, by: 0.6))
                                        .font(.system(size: 18))
                                        .bold()
                                        .monospaced()
                                })
                                .padding(.all)
                        }
                    })
                    .foregroundStyle(Color.white.mix(with: .gray, by: 0.25))
                    
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                
                RoundedRectangle(cornerRadius: 32)
                    .frame(maxWidth: .infinity, maxHeight: 999)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color.white.mix(with: .gray, by: 0.4), lineWidth: 4)
                            .overlay(content: {
                                
                            })
                    )
                    .foregroundStyle(Color.white.mix(with: .gray, by: 0.25))
                
                Spacer()
            }.padding(
                .all
            )
            
        }.frame(alignment: .top)
        //.background(.blue)
    }
}

#Preview {
    ContentView()
}
