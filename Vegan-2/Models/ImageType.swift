//
//  ImageType.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 12.10.2023.
//

import Foundation

enum ImageType: Hashable, Identifiable {
    case step(Int)
    case cover
    case profile
    var id: Self { self }
}
