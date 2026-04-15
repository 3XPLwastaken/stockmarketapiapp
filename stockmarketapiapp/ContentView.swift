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

    @StateObject private var wallet = Wallet.shared

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    RoundedRectangle(cornerRadius: 32)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.white.mix(with: .gray, by: 0.4), lineWidth: 4)
                        )
                        .overlay {
                            VStack {
                                HStack {
                                    Text(String(format: "$%.2f dollars", wallet.money ?? 0))
                                    
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
                                    .overlay {
                                        Text(Date.now.formatted())
                                            .foregroundStyle(.white.mix(with: .black, by: 0.6))
                                            .font(.system(size: 18))
                                            .bold()
                                            .monospaced()
                                    }
                                    .padding(.all)
                            }
                        }
                        .foregroundStyle(Color.white.mix(with: .gray, by: 0.25))

                    Spacer()
                    Spacer()

                    RoundedRectangle(cornerRadius: 32)
                        .frame(maxWidth: .infinity, maxHeight: 999)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.white.mix(with: .gray, by: 0.4), lineWidth: 4)
                                .overlay {
                                    Graph(name: "AAPL")
                                        .frame(width: 230, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                        )
                        .foregroundStyle(Color.white.mix(with: .gray, by: 0.25))
                        .padding(.bottom, 50)

                    Spacer()
                }
                .padding(.all)
            }
            .frame(alignment: .top)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .frame(maxWidth: .infinity, maxHeight: 999)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.mix(with: .gray, by: 0.4), lineWidth: 4)
                            .overlay {
                                HStack {
                                    Image(systemName: "house")
                                        .resizable()
                                        .foregroundStyle(.black.mix(with: .white, by: 0.5))
                                        .fontWeight(.semibold)
                                        .frame(width: 45, height: 40)
                                        .padding(.leading, 40)

                                    NavigationLink { SearchView() } label: {
                                        Image(systemName: "magnifyingglass")
                                            .resizable()
                                            .foregroundStyle(.black.mix(with: .white, by: 0.5))
                                            .frame(width: 35, height: 35)
                                    }
                                    .padding(.leading, 3)

                                    NavigationLink { CompanyShareView() } label: {
                                        Image(systemName: "list.bullet")
                                            .resizable()
                                            .foregroundStyle(.black.mix(with: .white, by: 0.5))
                                            .fontWeight(.semibold)
                                            .frame(width: 35, height: 30)
                                            .padding(.leading, 3)
                                    }
                                    
                                    Spacer()
                                    
                                    NavigationLink { CountryViewApp() } label: {
                                        Image(systemName: "gear")
                                            .resizable()
                                            .foregroundStyle(.black.mix(with: .white, by: 0.5))
                                            .fontWeight(.semibold)
                                            .frame(width: 40, height: 40)
                                            .padding(.trailing, 40)
                                            .padding(.leading, 3)
                                    }
                                }
                            }
                    )
                    .foregroundStyle(Color.white.mix(with: .gray, by: 0.25))
                    .ignoresSafeArea()
                    .padding(.top, UIScreen.main.bounds.height / 1.2)
            }
            .onAppear {
                // Create a wallet on first launch if none exists
                /*if wallet.isEmpty {
                    let wallet = Wallet()
                    modelContext.insert(wallet)
                }*/
            }
        }
    }
}

#Preview {
    ContentView()
}
