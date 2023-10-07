//
//  GradientProgressView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 5.10.2023.
//

import Foundation
import SwiftUI

struct GradientProgressView: View, Animatable {
        // gradient colors should be ordered so position cannot be less
        // then first color in gradient and more then last color in gradient
        @State private var animate = CGFloat(0.1)  // << left prgress position !!

        var body: some View {
            RoundedRectangle(cornerRadius: 12).fill(.clear)
                .modifier(GradientProgressEffect(position: animate))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .animation(.linear(duration: 2.0)
                    .repeatForever(autoreverses: true), value: animate)
                .onAppear {
                    animate = 0.9   // << right progress position !!
                }
        }

        struct GradientProgressEffect: AnimatableModifier {
            var position: CGFloat = 0

            var animatableData: CGFloat {
                get {
                    position
                } set {
                    position = newValue
                }
            }

            func body(content: Content) -> some View {
                content.background(
                    LinearGradient(
                        stops: [
                            .init(color: .gray.opacity(0.1), location: 0.0),
                            .init(color: .gray.opacity(0.5), location: position - 0.05),
                            .init(color: .gray.opacity(0.5), location: position + 0.05),
                            .init(color: .gray.opacity(0.1), location: 1.0),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                        //startPoint: UnitPoint(x: -0.5, y: 0.5),
                        //endPoint: UnitPoint(x: 1.5, y: 0.5)
                    )
                    // we need gradient wider than holder to avoid jaming at edges
                    .padding(.horizontal, -40)
                    .clipped()
                )
            }
        }
    }
