//
//  RecipeStore.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 7.10.2023.
//

/*import Foundation
import FirebaseFirestore

class RecipeStore: ObservableObject {
    static let shared = RecipeStore()
    private let db = FirestoreManager.shared
    private let firebaseAuth = AuthManager.shared
    
    private let currentUserDocumentRef: DocumentReference
    private let recipesCollectionRef: CollectionReference
    
    @Published var uniqueRecipes: [String: Recipe] = [:]
    
    private init() {
        currentUserDocumentRef = db.getFirestore().collection("users").document(firebaseAuth.getAuth().currentUser!.uid)
        recipesCollectionRef = currentUserDocumentRef.collection("recipes")
    }
    
    func fetchRecipes(count: Int, completion: @escaping (RecipeID?) -> Void) {
        for _ in 0 ..< count {
            let key = recipesCollectionRef.document().documentID
            
            let shouldTryLessFirst = Bool.random()
            
            let randomField = "\(Int.random(in: 1...3))"
            
            if shouldTryLessFirst {
                attemptFetchWithCondition(isLess: true, using: key, randomField: randomField) { docID in
                    completion(docID)
                }
            } else {
                attemptFetchWithCondition(isLess: false, using: key, randomField: randomField) { docID in
                    completion(docID)
                }
            }
        }
    }
    
    /*func attemptFetchWithCondition(isLess: Bool, using key: String, randomField: String, completion: @escaping (RecipeID?) -> Void) {
        
        let query: Query
        if isLess {
            query = recipesCollectionRef.whereField("random.\(randomField)", isLessThanOrEqualTo: key).order(by: "random.\(randomField)", descending: true).limit(to: 1)
            print(query)
        } else {
            query = recipesCollectionRef.whereField("random.\(randomField)", isGreaterThanOrEqualTo: key).order(by: "random.\(randomField)").limit(to: 1)
            print(query)
        }
        
        query.getDocuments() { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil) // Indicate an error occurred by returning nil.
                return
            }
            
            if let snapshot = snapshot, !snapshot.isEmpty, let document = snapshot.documents.first {
                let recipe = self.recipeFromDocument(document)
                
                if self.uniqueRecipes[document.documentID] == nil {
                    self.uniqueRecipes[document.documentID] = recipe
                }

                //completion(document.documentID)
                completion(RecipeID(id: UUID(), recipeID: document.documentID))
                
            } else {
                if isLess {
                    self.attemptFetchWithCondition(isLess: false, using: key, randomField: randomField, completion: completion)
                } else {
                    completion(nil) // No matching document found.
                }
            }
        }
    }*/

    
    func attemptFetchWithCondition(isLess: Bool, using key: String, randomField: String, completion: @escaping (RecipeID?) -> Void) {
        if isLess {
            recipesCollectionRef.whereField("random.\(randomField)", isLessThanOrEqualTo: key).order(by: "random.\(randomField)", descending: true).limit(to: 1).getDocuments() { (snapshot, error) in
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
                        
                        completion(RecipeID(id: UUID(), recipeID: document.documentID))
                    }
                } else {
                    self.attemptFetchWithCondition(isLess: false, using: key, randomField: randomField) { docID in
                        completion(docID)
                    }
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
                        
                        completion(RecipeID(id: UUID(), recipeID: document.documentID))
                        
                    }
                } else {
                    self.attemptFetchWithCondition(isLess: true, using: key, randomField: randomField) { docID in
                        completion(docID)
                    }
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
        
        if let coverPhotoURL = document.data()["coverPhotoURL"] as? String {
            recipe.coverPhotoURL = coverPhotoURL
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
                if let stepInstruction = steps["stepInstruction"] as? String,
                   let stepPhotoURL = steps["stepPhotoURL"] as? String {
                    let step = Step(stepInstruction: stepInstruction, stepPhotoURL: stepPhotoURL)
                    recipe.steps?.append(step)
                }
            }
        }
        
        recipe.id = document.documentID
        
        return recipe
    }
    
    /*func downloadAndAssignCoverPhoto(for id: String) async {
        print(uniqueRecipes[id]?.coverPhotoURL)
        if uniqueRecipes[id]?.coverPhoto == nil {
            if let coverPhotoURL = uniqueRecipes[id]?.coverPhotoURL,
               let url = URL(string: coverPhotoURL),
               let image = try? await downloadPhoto(from: url.absoluteString) {
                
                DispatchQueue.main.async {
                    self.uniqueRecipes[id]?.coverPhoto = image
                }
                
            } else {
                print("Failed to get or convert cover image URL for idZZZZZ: \(id)")
            }
        } else {
            print("Cover image already exists for the given id: \(id)")
        }
    }*/
    
    func downloadAndAssignCoverPhoto(for id: String) async {
        print("Hell")
        if uniqueRecipes[id]?.coverPhoto == nil {
            if let coverPhotoURL = uniqueRecipes[id]?.coverPhotoURL,
               let url = URL(string: coverPhotoURL) {
                
                do {
                    let image = try await downloadPhoto(from: url.absoluteString)
                    DispatchQueue.main.async {
                        self.uniqueRecipes[id]?.coverPhoto = image
                    }
                } catch let error as PhotoDownloadError {
                    switch error {
                    case .invalidURL:
                        print("Error: Invalid URL for id: \(id)")
                    case .failedDownload:
                        print("Error: Download failed for id: \(id)")
                    }
                } catch {
                    print("Unexpected error for id \(id): \(error).")
                }
                
            } else {
                print("Failed to get or convert cover image URL for idZZZZZ: \(id)")
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
}
*/
