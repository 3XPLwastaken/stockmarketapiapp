//
//  Tag.swift
//  stockmarketapiapp
//
//  Created by DANIEL ARGHAVANI BADRABAD on 3/9/26.
//

import SwiftUI

struct Tag : View {
    var title : String?
    var text : String?
    
    var style = 1
    
    var body: some View {
        if style == 0 {
            VStack(alignment: .leading, spacing: 2) {
                if (title != nil) {
                    Text(title!)
                        .font(.headline.pointSize(8))
                        .foregroundStyle(.secondary)
                }
                
                if (text != nil) {
                    Text(text!)
                        .font(.body.pointSize(12))
                        .multilineTextAlignment(.leading)
                        //.lineSpacing(4)
                }
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.horizontal)
            
            
        } else {
            
            
            VStack(alignment: .leading, spacing: 2) {
                if (text != nil) {
                    Text(text!)
                        .font(.body.pointSize(14))
                        .multilineTextAlignment(.leading)
                        //.lineSpacing(4)
                }
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.all, 10)
            .frame(maxHeight: 20)
            
            
        }
        
        
        
        
    }
}




/*//
 //  Tag.swift
 //  stockmarketapiapp
 //
 //  Created by DANIEL ARGHAVANI BADRABAD on 3/9/26.
 //

 import SwiftUI

 struct Tag : View {
     var title : String?
     var text : String?
     
     var body: some View {
         VStack(alignment: .leading, spacing: 8) {
             if (title != nil) {
                 Text(title!)
                     .font(.headline)
                     .foregroundStyle(.secondary)
             }
             
             if (text != nil) {
                 Text(text!)
                     .font(.body)
                     .lineSpacing(4)
             }
         }
         .padding()
         .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
         .padding(.horizontal)
     }
 }
*/
