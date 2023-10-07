//
//  Step.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 24.08.2023.
//

import Foundation
import SwiftUI

/*enum StepType {
    case text(String)
    case image(Image)
}

struct Step {
    var type: StepType
    //var order: Int
    
    init(_ input: String) {
        self.type = .text(input)
        //self.order = order
    }
    
    init(_ input: Image) {
        self.type = .image(input)
        //self.order = order
    }
}*/

/*struct Step {
    var instruction: String?
    //let image: Image
    var image: UIImage?
}*/

/*struct Step: Equatable {
    var instruction: String = ""
    var image: UIImage = UIImage()
}*/

struct Step: Equatable {
    var stepInstruction: String?
    var stepPhotoURL: String?
    var stepPhoto: UIImage?
}
