//
//  SearchView.swift
//  stockmarketapiapp
//
//  Created by NIKLAS THORSEN on 2/25/26.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchText: String = ""
    @State var companyName: [String] = ["Apple Inc","NVIDIA Corp"]
    
    var body: some View {
        ZStack {
            List{
                VStack{
                    
                }
            }
            VStack {
                Spacer()
                
                HStack() {
                    TextField("Search...", text: $searchText)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .glassEffect(.regular.interactive())
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )


                    Button {
                        print("Searching: \(searchText)")
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color(.black))
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 55, height: 55)
                            .glassEffect(.regular.interactive())
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                .padding()
                .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    SearchView()
}
