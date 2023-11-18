//
//  RecipeReelViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 28.08.2023.
//

import Foundation
import SwiftUI

class ReelViewModel: ObservableObject {
    
    //@Published var recipe: Recipe = Recipe()
    @Published var recipes: [Recipe] = []
    let recipeStore = RecipeStore.shared
    
    
    func fetchRecipesForReels(count: Int) {
        recipeStore.fetchRecipes(count: count) { recipes in
            /*if let recipeID = recipeID {
                self.recipes.append(recipeID)
            }*/
            self.recipes.append(contentsOf: recipes)
        }
    }
    
    /*func downloadAndAssignCoverPhoto(for id: String) async {
        await recipeStore.downloadAndAssignCoverPhoto(for: id)
    }*/
    
    func downloadAndAssignCoverPhoto(for id: String) async {
        if recipeStore.uniqueRecipes[id]?.coverPhoto == nil {
            if let coverPhotoURL = recipeStore.uniqueRecipes[id]?.coverPhotoURL,
               let url = URL(string: coverPhotoURL),
               let image = try? await downloadPhoto(from: url.absoluteString) {
                
                DispatchQueue.main.async {
                    self.recipeStore.uniqueRecipes[id]?.coverPhoto = image
                }
                
            } else {
                print("Failed to get or convert cover image URL for id: \(id)")
            }
        } else {
            //print("Cover image already exists for the given id: \(id)")
        }
    }
    
    enum PhotoDownloadError: Error {
        case invalidURL
        case failedDownload
    }

    func downloadPhoto(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw PhotoDownloadError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                return uiImage
            } else {
                throw PhotoDownloadError.failedDownload
            }
        } catch {
            throw PhotoDownloadError.failedDownload
        }
    }
    
}
