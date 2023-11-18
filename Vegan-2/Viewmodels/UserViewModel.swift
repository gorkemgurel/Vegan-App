//
//  ProfileViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 13.07.2023.
//

import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    //@Published var user: User = User(firstName: "", lastName: "", email: "", profilePicture: Image(systemName: "person.circle"), savedRecipes: [])
    @Published var user: User = User()
    //@Published var isLoggedIn: Bool = false
    //@Published var testName: String = ""
    let firebaseAuth = AuthManager.shared
    let db = FirestoreManager.shared
    
    private var updateTimer: Timer?
    private let debounceInterval = 2.0
    
    func fetchUserData() {
        guard let uid = firebaseAuth.getAuth().currentUser?.uid else {
            return
        }
        
        db.getFirestore().collection("users").document(uid).getDocument { snapshot, _ in
            if let user = snapshot?.data() {
                /*self.user.firstName = user["firstName"] as? String ?? ""
                self.user.lastName = user["lastName"] as? String ?? ""
                self.user.email = user["email"] as? String ?? ""
                self.user.userName = user["userName"] as? String ?? ""
                self.user.profilePhoto = user["profilePhoto"] as? UIImage ?? UIImage()
                self.user.submittedRecipes = user["submittedRecipes"] as? [String] ?? []
                self.user.likedRecipes = user["likedRecipes"] as? [String] ?? []
                self.user.following = user["following"] as? [String] ?? []
                self.user.followers = user["followers"] as? [String] ?? []*/
                self.user.firstName = user["firstName"] as? String ?? ""
                self.user.lastName = user["lastName"] as? String ?? ""
                self.user.email = user["email"] as? String ?? ""
                self.user.userName = user["userName"] as? String ?? ""
                self.user.profilePhoto = user["profilePhoto"] as? UIImage ?? UIImage()
                self.user.submittedRecipes = user["submittedRecipes"] as? [String] ?? []
                self.user.likedRecipes = user["likedRecipes"] as? [String] ?? []
                self.user.following = user["following"] as? [String] ?? []
                self.user.followers = user["followers"] as? [String] ?? []
                //self.user.id = uid
            } else {
                return
            }
        }
    }
    
    func toggleLike(for recipeID: String) {
        /*if let likedRecipes = user.likedRecipes {
            if (likedRecipes.contains(recipeID)) {
                
            }
        }*/
        if user.likedRecipes.contains(recipeID) {
            // Unlike the recipe
            if let index = user.likedRecipes.firstIndex(of: recipeID) {
                user.likedRecipes.remove(at: index)
            }
        } else {
            // Like the recipe
            user.likedRecipes.append(recipeID)
        }
        debounceUpdate()
    }
    
    private func debounceUpdate() {
            // Invalidate the current timer if there's one
            updateTimer?.invalidate()

            // Start a new timer
            updateTimer = Timer.scheduledTimer(withTimeInterval: debounceInterval, repeats: false) { [weak self] _ in
                self?.updateFirebase()
            }
        }

        private func updateFirebase() {

            let userRef = db.getFirestore().collection("users").document(user.userID ?? "")
            userRef.updateData([
                "likedRecipes": user.likedRecipes
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated!")
                }
            }
        }
    
    /*func fetchUserData() {
        guard let uid = firebaseAuth.getAuth().currentUser?.uid else {
            // User is not logged in or uid is not available
            return
        }
        
        db.getFirestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                // Handle Firestore document retrieval error
                print("Firestore document retrieval error: \(error)")
            } else if let snapshot = snapshot, snapshot.exists {
                // User document found
                if let data = snapshot.data() {
                    self.user.firstName = data["firstName"] as? String ?? ""
                    self.user.lastName = data["lastName"] as? String ?? ""
                    self.testName = data["firstName"] as? String ?? ""
                    // Process the retrieved user data
                    //print("User data: \(firstName), \(lastName), \(email)")
                    print("\(self.user.firstName) \(self.user.lastName)")
                }
            } else {
                // User document not found or does not exist
                print("User document not found")
            }
        }
    }*/

}

