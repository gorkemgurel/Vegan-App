//
//  RecipeReelViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 28.08.2023.
//

import Foundation
import SwiftUI

class RecipeReelViewModel: ObservableObject {
    
    
    @Published var recipe: Recipe = Recipe()
    @Published var recipes: [RecipeID] = []
    let recipeStore = RecipeStore.shared
    
    /*var title: String? {
        get { recipe.title }
        set { recipe.title = newValue }
    }
    
    var description: String? {
        get { recipe.description }
        set { recipe.description = newValue }
    }
    
    var prepTime: String? {
        get { recipe.prepTime }
        set { recipe.prepTime = newValue }
    }
    
    var servingSize: Int? {
        get { recipe.servingSize }
        set { recipe.servingSize = newValue }
    }
    
    var coverPhoto: UIImage? {
        get { recipe.coverPhoto }
        set { recipe.coverPhoto = newValue }
    }
    
    var coverPhotoURL: String? {
        get { recipe.coverPhotoURL }
        set { recipe.coverPhotoURL = newValue }
    }
    
    var category: String? {
        get { recipe.category }
        set { recipe.category = newValue }
    }
    
    var steps: [Step]? {
        get { recipe.steps }
        set { recipe.steps = newValue }
    }
    
    var id: String? {
        get { recipe.id }
        set { recipe.id = newValue }
    }*/
    
    func fetchRecipes(count: Int) {
        recipeStore.fetchRecipes(count: count) { recipeID in
            if let recipeID = recipeID {
                self.recipes.append(recipeID)
                print(self.recipes.count)
                /*DispatchQueue.main.async {
                    self.recipes.append(recipeID)
                    print(self.recipes.count)
                }*/
            }
        }
        //print(recipes.count)
    }
    
    func downloadAndAssignCoverPhoto(for id: String) async {
        await recipeStore.downloadAndAssignCoverPhoto(for: id)
    }
    
}
