//
//  RecipeAddViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 20.07.2023.
//

/*import Foundation
import SwiftUI
import PhotosUI

class RecipeAddViewModel: ObservableObject {
    @Published var recipe: Recipe
    let db = FirestoreManager.shared.getFirestore()
    let firebaseAuth = AuthManager.shared
    let storage = FirebaseStorageManager.shared
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var selectedPhotos: [UIImage] = []
    @Published var selectedPhoto: PhotosPickerItem?
    //let uid = firebaseAuth.getAuth().currentUser?.uid ?? ""
    
    init(recipe: Recipe = Recipe(coverImage: UIImage())) {
        self.recipe = recipe
    }
    
    /*var title: String {
        get { recipe.title }
        set { recipe.title = newValue }
    }*/
    
    var title: String? {
        get {
            if let title = recipe.title {
                return title
            }
            else {
                return nil
            }
        }
        set { recipe.title = newValue }
    }
    
    var description: String? {
        get {
            if let description = recipe.description {
                return description
            }
            else {
                return nil
            }
        }
        set { recipe.description = newValue }
    }
    
    var steps: [Step]? {
        get {
            if let steps = recipe.steps {
                return steps
            }
            else {
                return nil
            }
        }
        set { recipe.steps = newValue }
    }
    
    var prepTime: String? {
        get {
            if let prepTime = recipe.prepTime {
                return prepTime
            }
            else {
                return nil
            }
        }
        set { recipe.prepTime = newValue }
    }
    
    var servingSize: Int? {
        get {
            if let servingSize = recipe.servingSize {
                return servingSize
            }
            else {
                return nil
            }
        }
        set { recipe.servingSize = newValue }
    }
    
    var coverImage: UIImage? {
        get {
            if let coverImage = recipe.coverImage {
                return coverImage
            }
            else {
                return nil
            }
        }
        set { recipe.coverImage = newValue }
    }
    
    var category: String? {
        get {
            if let category = recipe.category {
                return category
            }
            else {
                return nil
            }
        }
        set { recipe.category = newValue }
    }
    
    var id: String? {
        get {
            if let id = recipe.id {
                return id
            }
            else {
                return nil
            }
        }
        set { recipe.id = newValue }
    }
    
    func addRecipe() {
        let newDocRef = db.collection("recipes").document()
        let newDocID = newDocRef.documentID
        //var stepsForFirestore: [[String: Any]] = [] //Testing
        var stepsForFirestore: [[String: Any]?] = Array(repeating: nil, count: recipe.steps?.count ?? 0)
        //var imageURLS: [String] = []
        var coverImageURL: String = ""
        recipe.userID = firebaseAuth.getAuth().currentUser!.uid
        let dispatchGroup = DispatchGroup()
        
        /*for (index, photo) in selectedPhotos.enumerated() {
            if let imageData = photo.jpegData(compressionQuality: 0.5) {
                let imagePath = "recipePhotos/\(newDocID)/\(index).jpg"
                
                dispatchGroup.enter()
                storage.uploadImageData(imageData, atPath: imagePath) { url, error in
                    if let error = error {
                        print("Error uploading image:", error)
                        return
                    }
                    if let url = url {
                        imageURLS.append(url.absoluteString)
                        print("Successfully uploaded image and got URL:", url)
                        print(imageURLS.count)
                        print(imageURLS[0])
                    }
                    dispatchGroup.leave()
                }
            }
        }*/ //selectedPhotos için çalışan kod
        if let steps = recipe.steps {
            for (index, step) in steps.enumerated() {
                // Convert the SwiftUI Image to UIKit UIImage first
                    // Convert UIImage to Data
                    if let imageData = step.image.jpegData(compressionQuality: 0.5) {
                        let imagePath = "recipePhotos/\(newDocID)/step\(index).jpg"

                        dispatchGroup.enter()
                        storage.uploadImageData(imageData, atPath: imagePath) { url, error in
                            if let error = error {
                                print("Error uploading image:", error)
                                return
                            }
                            /*if let url = url {
                                stepsForFirestore.append([
                                    "image": url.absoluteString,
                                    "instruction": step.instruction
                                ])
                            }*/
                            if let url = url {
                                stepsForFirestore[index] = [
                                    "image": url.absoluteString,
                                    "instruction": step.instruction
                                ]
                            }
                            dispatchGroup.leave()
                        }
                    }
            }
        }
        
        if let coverImage = recipe.coverImage {
            if let imageData = coverImage.jpegData(compressionQuality: 0.5) {
                let imagePath = "recipePhotos/\(newDocID)/coverImage.jpg"
                
                dispatchGroup.enter()
                storage.uploadImageData(imageData, atPath: imagePath) { url, error in
                    if let error = error {
                        print("Error uploading image:", error)
                        return
                    }
                    if let url = url {
                        coverImageURL = url.absoluteString
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        
        /*if let uiImage = recipe.coverImage {
            if let imageData = uiImage.jpegData(compressionQuality: 0.5) {
                let imagePath = "recipePhotos/\(newDocID)/coverImage.jpg"
                
                dispatchGroup.enter()
                storage.uploadImageData(imageData, atPath: imagePath) { url, error in
                    if let error = error {
                        print("Error uploading image:", error)
                        return
                    }
                    if let url = url {
                        coverImageURL = url.absoluteString
                    }
                    dispatchGroup.leave()
                }
            }
        }*/
        /*storage.uploadImageData(selectedPhotos[0].jpegData(compressionQuality: 0.5)!, atPath: "recipePhotos/\(newDocID)/0.jpg") { url, error in
            if let error = error {
                print("Error uploading image:", error)
                return
            }
            if let url = url {
                print("Successfully uploaded image and got URL:", url)
            }
        }*/
        dispatchGroup.notify(queue: .main) {
            //print(imageURLS[0])
            
            newDocRef.setData([
                "title": self.recipe.title ?? "",
                "description": self.recipe.description ?? "",
                "prepTime": self.recipe.prepTime ?? "",
                "servingSize": self.recipe.servingSize ?? 1,
                "category": self.recipe.category ?? "",
                "userID": self.recipe.userID ?? "",
                //"images": imageURLS
                "steps": stepsForFirestore,
                "coverImage": coverImageURL
                ]) { error in
                    if let error = error {
                        // Handle Firestore document creation error
                        print("Firestore document creation error: \(error)")
                    } else {
                        //self.firebaseAuth.checkLoggedIn()
                        // User document created successfully
                        print("User document created successfully")
                    }
                }
        }
        
         
        //print(selectedItems.count)
    }
}
*/
