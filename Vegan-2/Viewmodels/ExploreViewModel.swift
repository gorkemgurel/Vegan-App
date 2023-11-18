//
//  RecipeExploreViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 9.10.2023.
//

import Foundation
import SwiftUI

class ExploreViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    let recipeStore = RecipeStore.shared
    
    /*func fetchRecipesForExplore(count: Int) {
        recipeStore.fetchRecipes(count: count) { recipeID in
            self.recipes.append(contentsOf: recipeID)
        }
    }*/
    
    /*func fetchRecipesForExplore(count: Int) {
        recipeStore.fetchRecipes(count: count) { [weak self] recipeID in
            guard let self = self else { return }
            self.recipes.append(contentsOf: recipeID)
            print(recipeID)
            print(self.recipes)  // Now, print inside the closure after appending
        }
        // Removed the print(recipes) from here
    }*/
    
    func fetchRecipesForExplore(count: Int) {
        recipeStore.fetchRecipes(count: count) { recipeID in
            DispatchQueue.main.async {
                self.recipes.append(contentsOf: recipeID)
                //print(recipeID)
                //print(self.recipes)
            }
        }
    }

    
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
