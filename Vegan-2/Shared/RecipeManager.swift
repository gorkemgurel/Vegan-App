//
//  RecipeManager.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 18.08.2023.
//

/*import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
import FirebaseStorage

class RecipeManager: ObservableObject {
    // Singleton instance
    static let shared = RecipeManager()
    let db = FirestoreManager.shared
    @ObservedObject var firebaseAuth = AuthManager.shared
    
    let recipesDocument: CollectionReference
    //var key: String
    
    @Published var recipes: [Recipe] = []
    /*@Published var recipes: [Recipe] = [
        Recipe(title: "Vegan Pizza", description: "Vegan pizza, tamamen bitkisel malzemelerle hazırlanır ve bol miktarda taze sebze ve vegan peynir içerir.", images: [Image("Image 1")], prepTime: "15", servingSize: 2),
        Recipe(title: "Yoğurtlu Makarna", description: "Description 2", images: [Image("Image 2")], prepTime: "15", servingSize: 2),
        Recipe(title: "Pasta", description: "Description 3", images: [Image("Image 3")], prepTime: "15", servingSize: 2)
    ]*/
    
    private init() {
        recipesDocument = db.getFirestore().collection("recipes")
        //key = recipesDocument.document().documentID
        if (firebaseAuth.isUserAuthenticated) {
            test(times: 1)
            //test(times: 1)
            //test(times: 1)
            //test(times: 1)
        }
    }
    
    func test(times: Int) {
        for _ in 0..<times {
            let key = recipesDocument.document().documentID
            recipesDocument.whereField(FieldPath.documentID(), isGreaterThanOrEqualTo: key).limit(to: 1).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                if let snapshot = snapshot, !snapshot.isEmpty {
                    for document in snapshot.documents {
                        var recipe = Recipe()
                        recipe.title = document.data()["title"] as! String
                        recipe.description = document.data()["description"] as! String
                        recipe.prepTime = document.data()["prepTime"] as! String
                        recipe.servingSize = document.data()["servingSize"] as! Int
                        recipe.category = document.data()["category"] as! String
                        recipe.userID = document.data()["userID"] as! String
                        recipe.id = document.documentID
                        
                        let group = DispatchGroup()
                        
                        if let stepsData = document.data()["steps"] as? [[String: Any]] {
                            Task {
                                do {
                                    if let coverImageURL = document.data()["coverImage"] as? String {
                                        let coverImage = try await self.downloadCoverImage(from: coverImageURL)
                                        recipe.coverImage = coverImage
                                    }

                                    self.recipes.append(recipe)  // Assuming 'recipes' is thread-safe (use any required dispatch if not)
                                } catch {
                                    print("Error during downloading: \(error)")
                                    // Handle this as fits your app's needs.
                                }
                            }
                        }
                    }
                    /*for document in snapshot.documents {
                        //print("\(document.documentID) => \(document.data())")
                        var recipe = Recipe()
                        recipe.title = document.data()["title"] as! String
                        recipe.description = document.data()["description"] as! String
                        recipe.prepTime = document.data()["prepTime"] as! String
                        recipe.servingSize = document.data()["servingSize"] as! Int
                        recipe.category = document.data()["category"] as! String
                        recipe.userID = document.data()["userID"] as! String
                        recipe.id = document.documentID
                        //print(recipe.id)
                        /*self.downloadImages(from: document.data()["images"] as! [String]) { images in
                            recipe.images = images
                            self.recipes.append(recipe)
                            // Any other UI update or tasks you want to perform after fetching images
                        }*/
                        if let stepsData = document.data()["steps"] as? [[String: Any]] {
                            var steps: [Step] = []
                            for stepData in stepsData {
                                if let instruction = stepData["instruction"] as? String,
                                   let imageUrl = stepData["image"] as? String {
                                    self.downloadImage(from: imageUrl) { image in
                                        let step = Step(instruction: instruction, image: image)
                                        steps.append(step)
                                        print(steps.count)
                                        recipe.steps = steps
                                        
                                    }
                                }
                            }
                        } else {
                            print("1")
                        }
                        
                        if let coverImageURL = document.data()["coverImage"] as? String {
                            self.downloadImage(from: coverImageURL) { image in
                                recipe.coverImage = image
                                self.recipes.append(recipe)
                            }
                        } else {
                            print("2")
                        }
                        /*self.downloadImages(from: document.data()["images"] as! [String]) { images in
                            recipe.images = images
                            self.recipes.append(recipe)
                            // Any other UI update or tasks you want to perform after fetching images
                        }*/
                        //print(self.recipes.count)
                    }*/
                } else {
                    self.recipesDocument.whereField(FieldPath.documentID(), isLessThan: key).limit(to: 1).getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                            return
                        }
                        
                        /*for document in snapshot!.documents {
                            var recipe = Recipe()
                            recipe.title = document.data()["title"] as! String
                            recipe.description = document.data()["description"] as! String
                            recipe.prepTime = document.data()["prepTime"] as! String
                            recipe.servingSize = document.data()["servingSize"] as! Int
                            recipe.category = document.data()["category"] as! String
                            recipe.userID = document.data()["userID"] as! String
                            recipe.id = document.documentID
                            if let stepsData = document.data()["steps"] as? [[String: Any]] {
                                var steps: [Step] = []
                                for stepData in stepsData {
                                    if let instruction = stepData["instruction"] as? String,
                                       let imageUrl = stepData["image"] as? String {
                                        self.downloadImage(from: imageUrl) { image in
                                            let step = Step(instruction: instruction, image: image)
                                            steps.append(step)
                                            print(steps.count)
                                            recipe.steps = steps
                                            
                                        }
                                    }
                                }
                            } else {
                                print("3")
                            }
                            
                            if let coverImageURL = document.data()["coverImage"] as? String {
                                self.downloadImage(from: coverImageURL) { image in
                                    recipe.coverImage = image
                                    self.recipes.append(recipe)
                                }
                            } else {
                                print("4")
                            }
                            /*print(recipe.title)
                            self.downloadImages(from: document.data()["images"] as! [String]) { images in
                                recipe.images = images
                                self.recipes.append(recipe)
                                // Any other UI update or tasks you want to perform after fetching images
                            }*/
                        }*/
                        for document in snapshot!.documents {
                            var recipe = Recipe()
                            recipe.title = document.data()["title"] as! String
                            recipe.description = document.data()["description"] as! String
                            recipe.prepTime = document.data()["prepTime"] as! String
                            recipe.servingSize = document.data()["servingSize"] as! Int
                            recipe.category = document.data()["category"] as! String
                            recipe.userID = document.data()["userID"] as! String
                            recipe.id = document.documentID
                            
                            //let group = DispatchGroup()
                            
                            if let stepsData = document.data()["steps"] as? [[String: Any]] {
                                Task {
                                    do {
                                        if let coverImageURL = document.data()["coverImage"] as? String {
                                            let coverImage = try await self.downloadCoverImage(from: coverImageURL)
                                            recipe.coverImage = coverImage
                                        }

                                        self.recipes.append(recipe)  // Assuming 'recipes' is thread-safe (use any required dispatch if not)
                                    } catch {
                                        print("Error during downloading: \(error)")
                                        // Handle this as fits your app's needs.
                                    }
                                }


                            }
                        }
                    }
                }
            }
            }
        
        //print(recipes.count)
    }
    
    func downloadStepsImages(from stepsData: [[String: Any]]) async throws -> [Step] {
        var steps: [Step] = []

        for stepData in stepsData {
            if let instruction = stepData["instruction"] as? String,
               let imageUrl = stepData["image"] as? String {
                let image = try await self.downloadImage(from: imageUrl)
                let step = Step(instruction: instruction, image: image)
                steps.append(step)
            }
        }
        return steps
    }

    func downloadCoverImage(from urlString: String) async throws -> UIImage {
        let image = try await self.downloadImage(from: urlString)
        return image
    }

    
    /*func downloadImage(from urlString: String, completion: @escaping (UIImage) -> Void) {
        let group = DispatchGroup()
        var fetchedImage = UIImage()
        
        if let url = URL(string: urlString) {
            group.enter()
            
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let data = data, let uiImage = UIImage(data: data) {
                    print("Downloaded image size: \(uiImage.size.width) x \(uiImage.size.height)") // <-- Here's the print statement
                    fetchedImage = uiImage
                }
                else if let error = error {
                    print("Error fetching image: \(error)")
                }
                group.leave()
            }.resume()
        }
        group.notify(queue: .main) {
            completion(fetchedImage)
        }
    }*/

    
    /*func downloadImage(from urlString: String, completion: @escaping (UIImage) -> Void) {
        let group = DispatchGroup()
        var fetchedImage = UIImage()
        
        if let url = URL(string: urlString) {
            group.enter()
            
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let data = data, let uiImage = UIImage(data: data) {
                    let image = uiImage
                    fetchedImage = image
                }
                else if let error = error {
                    print("Error fetching image: \(error)")
                }
                group.leave()
            }.resume()
        }
        group.notify(queue: .main) {
            completion(fetchedImage)
        }
    }*/
    
    /*func downloadImages(from urls: [String], completion: @escaping ([Image]) -> Void) {
        let group = DispatchGroup()
        var fetchedImages: [Image] = []

        for urlString in urls {
            guard let url = URL(string: urlString) else {
                continue
            }

            group.enter()

            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let data = data, let uiImage = UIImage(data: data) {
                    let image = Image(uiImage: uiImage)
                    fetchedImages.append(image)
                    print(fetchedImages.count)
                } else if let error = error {
                    print("Error fetching image: \(error)")
                }

                group.leave()
            }.resume()
        }

        group.notify(queue: .main) {
            completion(fetchedImages)
        }
    }*/
    
    enum ImageDownloadError: Error {
        case invalidURL
        case failedDownload
    }

    func downloadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw ImageDownloadError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                return uiImage
            } else {
                throw ImageDownloadError.failedDownload
            }
        } catch {
            throw ImageDownloadError.failedDownload
        }
    }

    
}
*/
