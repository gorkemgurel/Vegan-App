//
//  Recipe.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 10.07.2023.
//

import Foundation
import SwiftUI

/*struct Recipe: Identifiable {
    var title: String = ""
    var description: String = ""
    var coverImage: UIImage = UIImage()
    var prepTime: String = ""
    var servingSize: Int = 1
    var category: String = ""
    var userID: String = ""
    var steps: [Step] = []
    var id: String = ""
    //var id: UUID = UUID()
    var recipeIndex: Int = 0
}*/

struct Recipe: Identifiable {
    
    /*static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description && lhs.coverImage == rhs.coverImage && lhs.prepTime == rhs.prepTime && lhs.servingSize == rhs.servingSize && lhs.category == rhs.category && lhs.userID == rhs.userID && lhs.steps == rhs.steps && lhs.id == rhs.id && lhs.recipeIndex == rhs.recipeIndex
    }*/
    
    var title: String = ""
    var description: String = ""
    var coverPhoto: UIImage?
    var coverPhotoURL: String?
    var prepTime: String = ""
    var servingSize: Int = 1
    var category: String = ""
    var userID: String = ""
    var steps: [Step] = []
    var recipeID = ""
    var id: UUID?
    //var stepURLs: [String]?
    //var id: String?
    //var recipeIndex: Int?
}
