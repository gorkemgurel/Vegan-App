//
//  ViewfinderView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 15.10.2023.
//

import SwiftUI

struct ViewfinderView: View {
    @Binding var image: Image?
    
    var body: some View {
        GeometryReader { geometry in
            /*VStack {
                Spacer()
                if let image = image {
                    image
                        .resizable()
                        .scaledToFit()
                        //.frame(width: geometry.size.width, height: geometry.size.width)
                }
            }*/
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    //.frame(width: geometry.size.width, height: geometry.size.width)
            }
        }
    }
}
