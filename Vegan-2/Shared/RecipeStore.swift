//
//  RecipeStore.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 9.10.2023.
//

import Foundation
import FirebaseFirestore

class RecipeStore: ObservableObject {
    
    static let shared = RecipeStore()
    
    private let db = FirestoreManager.shared
    private let firebaseAuth = AuthManager.shared
    
    @Published var uniqueRecipes: [String: Recipe] = [:]
    
    private let currentUserDocumentRef: DocumentReference
    private let recipesCollectionRef: CollectionReference
    
    init() {
        currentUserDocumentRef = db.getFirestore().collection("users").document(firebaseAuth.getAuth().currentUser!.uid)
        recipesCollectionRef = currentUserDocumentRef.collection("recipes")
    }
    
    /*func fetchRecipes(count: Int, completion: @escaping (RecipeID?) -> Void) {
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
    }*/
    
    func fetchRecipes(count: Int, completion: @escaping ([Recipe]) -> Void) {
        var results: [Recipe] = []
        let group = DispatchGroup()
        
        for _ in 0 ..< count {
            group.enter()
            let key = recipesCollectionRef.document().documentID
            let shouldTryLessFirst = Bool.random()
            let randomField = "\(Int.random(in: 1...3))"
            
            let fetchCompletion: (Recipe?) -> Void = { docID in
                if let docID = docID {
                    results.append(docID)
                }
                group.leave()
            }
            
            if shouldTryLessFirst {
                attemptFetchWithCondition(isLess: true, using: key, randomField: randomField, completion: fetchCompletion)
            } else {
                attemptFetchWithCondition(isLess: false, using: key, randomField: randomField, completion: fetchCompletion)
            }
        }
        
        group.notify(queue: .main) {
            //print(results)
            completion(results)
        }
    }

    
    func attemptFetchWithCondition(isLess: Bool, using key: String, randomField: String, completion: @escaping (Recipe?) -> Void) {
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
                        
                        //completion(RecipeID(id: UUID(), recipeID: document.documentID))
                        completion(recipe)
                    }
                } else {
                    self.attemptFetchWithCondition(isLess: false, using: key, randomField: randomField) { recipe in
                        completion(recipe)
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
                        
                        //completion(RecipeID(id: UUID(), recipeID: document.documentID))
                        completion(recipe)
                        
                    }
                } else {
                    self.attemptFetchWithCondition(isLess: true, using: key, randomField: randomField) { recipe in
                        completion(recipe)
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
                    recipe.steps.append(step)
                }
            }
        }
        
        recipe.recipeID = document.documentID
        recipe.id = UUID()
        
        return recipe
    }
    
    /*private func recipeFromDocument(_ document: QueryDocumentSnapshot) -> Recipe {
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
        
        //recipe.id = document.documentID
        
        return recipe
    }*/
}
