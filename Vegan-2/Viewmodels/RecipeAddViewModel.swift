//
//  RecipeAddViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 9.10.2023.
//

import Foundation
import FirebaseFirestore

class RecipeAddViewModel: ObservableObject {
    
    @Published var recipe = Recipe()
    @Published var readyToGoToCamera = false
    @Published var imageType: ImageType?
    
    private let db = FirestoreManager.shared
    private let firebaseAuth = AuthManager.shared
    private let storage = FirebaseStorageManager.shared
    
    private let currentUserDocumentRef: DocumentReference
    private let recipesCollectionRef: CollectionReference
    
    init() {
        currentUserDocumentRef = db.getFirestore().collection("users").document(firebaseAuth.getAuth().currentUser!.uid)
        recipesCollectionRef = currentUserDocumentRef.collection("recipes")
    }
    
    func addRecipe() {
        let newDocID = recipesCollectionRef.document().documentID
        var stepsForFirestore: [[String: Any]]?
        //var stepsForFirestore: [String: [String: Any]]?
        var coverPhotoURL: String = ""
        let dispatchGroup = DispatchGroup()
        
        var stepIndex = 1
        
        for step in recipe.steps {
            if let stepPhoto = step.stepPhoto {
                if let compressedStepPhoto = stepPhoto.jpegData(compressionQuality: 0.5) {
                    let stepPhotoPath = "userPhotos/\(firebaseAuth.getAuth().currentUser!.uid)/recipePhotos/\(newDocID)/stepPhotos/step_\(stepIndex).jpg"
                    stepIndex += 1
                    dispatchGroup.enter()
                    uploadPhoto(compressedStepPhoto, atPath: stepPhotoPath) { url, error in
                        if let error = error {
                            print("Error uploading step photo:", error)
                            dispatchGroup.leave()
                            return
                        }
                        if let url = url {
                            let stepData: [String: Any] = [
                                "stepPhotoURL": url.absoluteString,
                                "stepInstruction": step.stepInstruction
                            ]
                            //stepsForFirestore.append(stepData) // append the step data directly to the array
                            //stepsForFirestore["zort"] = stepData
                            //stepsForFirestore[0] = stepData
                            stepsForFirestore?.append(stepData) ?? (stepsForFirestore = [stepData])
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        if let coverPhoto = recipe.coverPhoto {
            if let compressedCoverPhoto = coverPhoto.jpegData(compressionQuality: 0.5) {
                let coverPhotoPath = "userPhotos/\(firebaseAuth.getAuth().currentUser!.uid)/recipePhotos/\(newDocID)/coverPhoto.jpg"
                
                dispatchGroup.enter()
                uploadPhoto(compressedCoverPhoto, atPath: coverPhotoPath) { url, error in
                    if let error = error {
                        print("Error uploading photo:", error)
                        dispatchGroup.leave()
                        return
                    }
                    if let url = url {
                        coverPhotoURL = url.absoluteString
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let data: [String: Any] = [
                "title": self.recipe.title,
                "description": self.recipe.description,
                "prepTime": self.recipe.prepTime,
                "servingSize": self.recipe.servingSize,
                "category": self.recipe.category,
                "steps": stepsForFirestore as Any, // use the array of dictionaries directly here
                "coverPhotoURL": coverPhotoURL,
                "random": [
                    "1": self.recipesCollectionRef.document().documentID,
                    "2": self.recipesCollectionRef.document().documentID,
                    "3": self.recipesCollectionRef.document().documentID
                ]
            ]
            
            //self.recipesDocument.document().setData(data) { error in
            self.recipesCollectionRef.document(newDocID).setData(data) { error in
                if let error = error {
                    print("Firestore document creation error: \(error)")
                } else {
                    print("User document created successfully")
                }
            }
        }
    }
    
    private func uploadPhoto(_ data: Data, atPath path: String, completion: @escaping (URL?, Error?) -> Void) {
        let storageRef = storage.getStorage().reference().child(path)
        storageRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                completion(nil, error)
                return
            }
            storageRef.downloadURL { url, error in
                completion(url, error)
            }
        }
    }
}
