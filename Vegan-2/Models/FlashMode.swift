//
//  FlashMode.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 16.10.2023.
//

import Foundation

enum FlashMode {
    case auto
    case on
    case off

    mutating func toggle() {
        switch self {
        case .auto:
            self = .on
        case .on:
            self = .off
        case .off:
            self = .auto
        }
    }
}
