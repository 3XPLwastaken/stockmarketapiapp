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
        NavigationStack {
            ZStack {
                VStack {
                    RoundedRectangle(cornerRadius: 32)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(
                                    Color.white.mix(with: .gray, by: 0.4),
                                    lineWidth: 4
                                )
                                .overlay(content: {

                                })
                        )
                        .overlay(content: {
                            VStack {
                                HStack {
                                    Text("$2000 dollars")
                                        .foregroundStyle(
                                            .green.mix(with: .black, by: 0.1)
                                        )
                                        .font(.system(size: 20))
                                        .bold()
                                        .monospaced()
                                        .padding(.all, 30.0)

                                    Spacer()

                                    Text("- $14")
                                        .foregroundStyle(
                                            .red.mix(with: .black, by: 0.1)
                                        )
                                        .font(.system(size: 20))
                                        .bold()
                                        .monospaced()
                                        .padding(.all, 30.0)
                                        .multilineTextAlignment(.trailing)
                                }

                                Spacer()

                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        Color.white.mix(with: .gray, by: 0.4),
                                        lineWidth: 4
                                    )
                                    .overlay(content: {
                                        Text("Market closes in: 10 hrs")
                                            .foregroundStyle(
                                                .white.mix(
                                                    with: .black,
                                                    by: 0.6
                                                )
                                            )
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

                    RoundedRectangle(cornerRadius: 32)
                        .frame(maxWidth: .infinity, maxHeight: 999)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(
                                    Color.white.mix(with: .gray, by: 0.4),
                                    lineWidth: 4
                                )
                                .overlay(content: {

                                })
                        )
                        .foregroundStyle(Color.white.mix(with: .gray, by: 0.25))
                        .padding(.bottom, 50)

                    Spacer()
                }.padding(
                    .all
                )

            }.frame(alignment: .top)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(maxWidth: .infinity, maxHeight: 999)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    Color.white.mix(with: .gray, by: 0.4),
                                    lineWidth: 4
                                )
                                .overlay(content: {
                                    HStack {
                                        Image(systemName: "house")
                                            .resizable()
                                            .foregroundStyle(
                                                .black.mix(
                                                    with: .white,
                                                    by: 0.5
                                                )
                                            )
                                            .fontWeight(.semibold)
                                            .frame(
                                                width: 45,
                                                height: 40,
                                                alignment: .center
                                            )
                                            //.padding(.all)
                                            .padding(.leading, 40)

                                        NavigationLink {
                                            SearchView()
                                        } label: {
                                            Image(systemName: "magnifyingglass")
                                                .resizable()
                                                .foregroundStyle(
                                                    .black.mix(
                                                        with: .white,
                                                        by: 0.5
                                                    )
                                                )
                                                .frame(width: 35, height: 35)
                                        }
                                        .padding(.leading, 3)

                                        Image(systemName: "list.bullet")
                                            .resizable()
                                            .foregroundStyle(
                                                .black.mix(
                                                    with: .white,
                                                    by: 0.5
                                                )
                                            )
                                            .fontWeight(.semibold)
                                            .frame(
                                                width: 35,
                                                height: 30,
                                                alignment: .center
                                            )
                                            .padding(.leading, 3)

                                        Spacer()

                                        Image(systemName: "gear")
                                            .resizable()
                                            .foregroundStyle(
                                                .black.mix(
                                                    with: .white,
                                                    by: 0.5
                                                )
                                            )
                                            .fontWeight(.semibold)
                                            .frame(
                                                width: 40,
                                                height: 40,
                                                alignment: .center
                                            )
                                            .padding(.trailing, 40)
                                            .padding(.leading, 3)

                                    }
                                })
                        )
                        .foregroundStyle(Color.white.mix(with: .gray, by: 0.25))
                        .ignoresSafeArea()
                        .padding(.top, UIScreen.main.bounds.height / 1.2)
                }

                .onAppear {
                    Task {
                        let sock = FinnhubAPI.listenForMarketChanges(
                            marketName: "AAPL"
                        ) { json in
                            print("GOT MARKET CHANGE!!!")
                        }

                        print("Yields...")

                        do {
                            try await sock.WEBSOCKET.send(
                                """
                                {"type":"subscribe","symbol":"AAPL"}
                                """
                            )
                        } catch {
                            print("Send failed:", error)
                        }
                    }
                }
            //.background(.blue)
        }
    }
}

#Preview {
    ContentView()
}
