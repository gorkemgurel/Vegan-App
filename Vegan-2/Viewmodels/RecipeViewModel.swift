//
//  RecipeViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 9.10.2023.
//

import Foundation
import SwiftUI

class RecipeViewModel: ObservableObject {
    var recipeID: String
    let recipeStore = RecipeStore.shared
    
    init(recipeID: String) {
        self.recipeID = recipeID
    }
    
    func downloadAndAssignStepPhotos(for recipeID: String, atIndex index: Int) async {
        if (recipeStore.uniqueRecipes[recipeID]?.steps[index].stepPhoto == nil) {
            print(recipeStore.uniqueRecipes[recipeID]?.steps[index].stepPhotoURL)
            if let stepPhotoURL = recipeStore.uniqueRecipes[recipeID]?.steps[index].stepPhotoURL,
               let url = URL(string: stepPhotoURL),
               let photo = try? await downloadPhoto(from: url.absoluteString) {
                DispatchQueue.main.async {
                    self.recipeStore.uniqueRecipes[recipeID]?.steps[index].stepPhoto = photo
                }
            } else {
                print("Failed to get or convert step photo URL for id: \(recipeID) and this index: \(index)")
            }
        } else {
            //print("Step image already exists for the given id: \(id) and index: \(index)")
        }
    }
    
    /*func downloadAndAssignStepPhotos(for recipeID: String, atIndex index: Int) async {
        if (recipeStore.uniqueRecipes[recipeID]?.steps?[index].stepPhoto == nil) {
            if let stepPhotoURL = recipeStore.uniqueRecipes[recipeID]?.steps?[index].stepPhotoURL,
               let url = URL(string: stepPhotoURL),
               let photo = try? await downloadPhoto(from: url.absoluteString) {
                DispatchQueue.main.async {
                    self.recipeStore.uniqueRecipes[recipeID]?.steps?[index].stepPhoto = photo
                }
            } else {
                print("Failed to get or convert cover photo URL for id: \(recipeID)")
            }
        } else {
            //print("Step image already exists for the given id: \(id) and index: \(index)")
        }
    }*/
    
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
