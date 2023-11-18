//
//  Step.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 24.08.2023.
//

import Foundation
import SwiftUI

struct Step: Identifiable {
    var stepInstruction: String = ""
    var stepPhotoURL: String?
    var stepPhoto: UIImage?
    var id: UUID?
}
