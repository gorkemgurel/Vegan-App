//
//  RecipeViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 29.08.2023.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseFirestore

class RecipeViewModel: ObservableObject {
    static let shared = RecipeViewModel()
    @Published var recipe: Recipe = Recipe()
    @Published var recipes: [Recipe] = []
    @Published var uniqueRecipes: [String: Recipe] = [:]
    
    private let db = FirestoreManager.shared
    private let firebaseAuth = AuthManager.shared
    let storage = FirebaseStorageManager.shared
    @Published var selectedPhoto: PhotosPickerItem?
    
    private let currentUserDocumentRef: DocumentReference
    private let recipesCollectionRef: CollectionReference
    
    private init() {
        currentUserDocumentRef = db.getFirestore().collection("users").document(firebaseAuth.getAuth().currentUser!.uid)
        recipesCollectionRef = currentUserDocumentRef.collection("recipes")
    }
    
    var title: String? {
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
    }
    
    func downloadAndAssignCoverImage(for id: String) async {
        if uniqueRecipes[id]?.coverPhoto == nil {
            if let coverImageURL = uniqueRecipes[id]?.coverPhotoURL,
               let url = URL(string: coverImageURL),
               let image = try? await downloadPhoto(from: url.absoluteString) {
                
                DispatchQueue.main.async {
                    self.uniqueRecipes[id]?.coverPhoto = image
                }
                
            } else {
                print("Failed to get or convert cover image URL for id: \(id)")
            }
        } else {
            print("Cover image already exists for the given id: \(id)")
        }
    }
    
    func downloadAndAssignStepPhotos(for recipeID: String, atIndex index: Int) async {
        if (uniqueRecipes[recipeID]?.steps?[index].stepPhoto == nil) {
            if let stepPhotoURL = uniqueRecipes[recipeID]?.steps?[index].stepPhotoURL,
               let url = URL(string: stepPhotoURL),
               let photo = try? await downloadPhoto(from: url.absoluteString) {
                DispatchQueue.main.async {
                    self.uniqueRecipes[recipeID]?.steps?[index].stepPhoto = photo
                }
            } else {
                print("Failed to get or convert cover photo URL for id: \(recipeID)")
            }
        } else {
            //print("Step image already exists for the given id: \(id) and index: \(index)")
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
    
    func fetchRecipes(count: Int) {
        for _ in 0 ..< count {
            let key = recipesCollectionRef.document().documentID
            
            let shouldTryLessFirst = Bool.random()
            
            let randomField = "\(Int.random(in: 1...3))"
            
            if shouldTryLessFirst {
                attemptFetchWithCondition(isLess: true, using: key, randomField: randomField)
            } else {
                attemptFetchWithCondition(isLess: false, using: key, randomField: randomField)
            }
        }
    }
    
    func attemptFetchWithCondition(isLess: Bool, using key: String, randomField: String) {
        if isLess {
            recipesCollectionRef.whereField("random.\(randomField)", isLessThanOrEqualTo: key).order(by: "random.\(randomField)", descending: true).limit(to: 1).getDocuments() { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                if let snapshot = snapshot, !snapshot.isEmpty {
                    //print("less")
                    //self.recipes.append(contentsOf: snapshot.documents.map(self.recipeFromDocument))
                    for document in snapshot.documents {
                                        let recipe = self.recipeFromDocument(document)
                                        //self.keysArray.append(recipe.id)
                                        //self.recipes[recipe.id] = recipe
                        if (self.uniqueRecipes[document.documentID] == nil) {
                            self.uniqueRecipes[document.documentID] = recipe
                        }
                        
                        self.recipes.append(recipe)
                    }
                } else {
                    self.attemptFetchWithCondition(isLess: false, using: key, randomField: randomField)
                }
            }
        } else {
            recipesCollectionRef.whereField("random.\(randomField)", isGreaterThanOrEqualTo: key).order(by: "random.\(randomField)").limit(to: 1).getDocuments() { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                if let snapshot = snapshot, !snapshot.isEmpty {
                    for document in snapshot.documents {
                        let recipe = self.recipeFromDocument(document)
                        
                        if (self.uniqueRecipes[document.documentID] == nil) {
                            self.uniqueRecipes[document.documentID] = recipe
                        }
                             
                        self.recipes.append(recipe)
                    }
                } else {
                    self.attemptFetchWithCondition(isLess: true, using: key, randomField: randomField)
                }
            }
        }
    }
    
    private func recipeFromDocument(_ document: QueryDocumentSnapshot) -> Recipe {
        var recipe = Recipe()
        
        if let title = document.data()["title"] as? String {
            recipe.title = title
        }
        
        if let description = document.data()["description"] as? String {
            recipe.description = description
        }
        
        if let coverImageURL = document.data()["coverImageURL"] as? String {
            recipe.coverPhotoURL = coverImageURL
        }
        
        if let prepTime = document.data()["prepTime"] as? String {
            recipe.prepTime = prepTime
        }

        if let servingSize = document.data()["servingSize"] as? Int {
            recipe.servingSize = servingSize
        }

        if let category = document.data()["category"] as? String {
            recipe.category = category
        }

        if let userID = document.data()["userID"] as? String {
            recipe.userID = userID
        }

        if let stepData = document.data()["steps"] as? [[String: Any]] {
            recipe.steps = []
            
            for steps in stepData {
                if let instruction = steps["instruction"] as? String,
                   let photoURL = steps["image"] as? String {
                    let step = Step(stepInstruction: instruction, stepPhotoURL: photoURL)
                    recipe.steps?.append(step)
                }
            }
        }

        recipe.id = document.documentID

        return recipe
    }
    
    func addRecipe() {
        let newDocID = recipesCollectionRef.document().documentID
        var stepsForFirestore: [[String: Any]] = [] // initialize as empty array
        var coverPhotoURL: String = ""
        //let userID = firebaseAuth.getAuth().currentUser!.uid
        let dispatchGroup = DispatchGroup()
        
        //for step in (recipe.steps ?? []) {
        for step in (steps ?? []) {
            if let stepPhotoData = (step.stepPhoto ?? UIImage()).jpegData(compressionQuality: 0.5) {
                //let imagePath = "recipePhotos/\(newDocID)/step\(stepsForFirestore.count).jpg" // use the current count of stepsForFirestore as the index
                let stepPhotoPath = "userPhotos/\(firebaseAuth.getAuth().currentUser!.uid)/recipePhotos/\(newDocID)/stepPhotos/step_\(stepsForFirestore.count + 1).jpg"
                dispatchGroup.enter()
                uploadPhoto(stepPhotoData, atPath: stepPhotoPath) { url, error in
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
                        stepsForFirestore.append(stepData) // append the step data directly to the array
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        //if let coverPhotoData = (recipe.coverPhoto ?? UIImage()).jpegData(compressionQuality: 0.5) {
        if let coverPhotoData = (coverPhoto ?? UIImage()).jpegData(compressionQuality: 0.5) {
            //let photoPath = "recipePhotos/\(newDocID)/coverImage.jpg"
            let coverPhotoPath = "userPhotos/\(firebaseAuth.getAuth().currentUser!.uid)/recipePhotos/\(newDocID)/coverPhoto.jpg"
            
            dispatchGroup.enter()
            uploadPhoto(coverPhotoData, atPath: coverPhotoPath) { url, error in
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
        
        dispatchGroup.notify(queue: .main) {
            let data: [String: Any] = [
                /*"title": self.recipe.title ?? "",
                "description": self.recipe.description ?? "",
                "prepTime": self.recipe.prepTime ?? "",
                "servingSize": self.recipe.servingSize ?? 1,
                "category": self.recipe.category ?? "",*/
                "title": self.title ?? "",
                "description": self.description ?? "",
                "prepTime": self.prepTime ?? "",
                "servingSize": self.servingSize ?? 1,
                "category": self.category ?? "",
                "userID": self.firebaseAuth.getAuth().currentUser!.uid,
                //"userID": self.recipe.userID ?? "",
                "steps": stepsForFirestore, // use the array of dictionaries directly here
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
