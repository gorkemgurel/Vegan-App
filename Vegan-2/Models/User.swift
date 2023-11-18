//
//  User.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 13.07.2023.
//

import Foundation
import SwiftUI

struct User: Identifiable {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var userName: String = ""
    var profilePhoto: UIImage?
    var profilePhotoURL: String?
    var submittedRecipes: [String] = []
    var likedRecipes: [String] = []
    var following: [String] = []
    var followers: [String] = []
    var userID: String?
    var id: UUID?
}
