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

    /*init() {
        self.user = User(
            firstName: "",
            lastName: "",
            email: "",
            userName: "",
            profilePicture: UIImage(),
            submittedRecipes: [],
            likedRecipes: [],
            following: [],
            followers: [],
            id: ""
        )
    }*/
    
    /*init(user: User) {
        self.user = user
    }*/
    
    var firstName: String? {
        get { user.firstName }
        set { user.firstName = newValue }
    }
    
    var lastName: String? {
        get { user.lastName }
        set { user.lastName = newValue }
    }
    
    var email: String? {
        get { user.email }
        set { user.email = newValue }
    }
    
    var userName: String? {
        get { user.userName }
        set { user.userName = newValue }
    }
    
    var profilePhoto: UIImage? {
        get { user.profilePhoto }
        set { user.profilePhoto = newValue }
    }
    
    var submittedRecipes: [String]? {
        get { user.submittedRecipes }
        set { user.submittedRecipes = newValue }
    }
    
    var likedRecipes: [String]? {
        get { user.likedRecipes }
        set { user.likedRecipes = newValue }
    }
    
    var following: [String]? {
        get { user.following }
        set { user.following = newValue }
    }
    
    var followers: [String]? {
        get { user.followers }
        set { user.followers = newValue }
    }
    
    var id: String? {
        get { user.id }
        set { user.id = newValue }
    }

    /*func updateProfilePicture(_ image: Image) {
        user.profilePicture = image
    }*/
    

    /*func addSavedRecipe(_ recipeId: Int) {
        user.savedRecipes.append(recipeId)
    }*/

    /*func removeSavedRecipe(_ recipeId: Int) {
        user.savedRecipes.removeAll(where: { $0 == recipeId })
    }*/
    
    /*func fetchUserData() {
        db.fetchUserData { fetchedUser in
            if let user = fetchedUser {
                self.user.firstName = user["firstName"] as? String ?? ""
                self.user.lastName = user["lastName"] as? String ?? ""
                self.user.email = user["email"] as? String ?? ""
                self.user.userName = user["userName"] as? String ?? ""
                self.user.profilePicture = user["profilePicture"] as? UIImage ?? UIImage()
                self.user.submittedRecipes = user["submittedRecipes"] as? [String] ?? []
                self.user.likedRecipes = user["likedRecipes"] as? [String] ?? []
                self.user.following = user["following"] as? [String] ?? []
                self.user.followers = user["followers"] as? [String] ?? []
            }
        }
    }*/
    
    /*func fetchUserData(for userID: String) {
        
        db.getFirestore().collection("users").document(userID).getDocument { snapshot, _ in
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
                self.firstName = user["firstName"] as? String ?? ""
                self.lastName = user["lastName"] as? String ?? ""
                self.email = user["email"] as? String ?? ""
                self.userName = user["userName"] as? String ?? ""
                self.profilePhoto = user["profilePhoto"] as? UIImage ?? UIImage()
                self.submittedRecipes = user["submittedRecipes"] as? [String] ?? []
                self.likedRecipes = user["likedRecipes"] as? [String] ?? []
                self.following = user["following"] as? [String] ?? []
                self.followers = user["followers"] as? [String] ?? []
                //self.user.id = uid
            } else {
                return
            }
        }
    }*/
    
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
                self.firstName = user["firstName"] as? String ?? ""
                self.lastName = user["lastName"] as? String ?? ""
                self.email = user["email"] as? String ?? ""
                self.userName = user["userName"] as? String ?? ""
                self.profilePhoto = user["profilePhoto"] as? UIImage ?? UIImage()
                self.submittedRecipes = user["submittedRecipes"] as? [String] ?? []
                self.likedRecipes = user["likedRecipes"] as? [String] ?? []
                self.following = user["following"] as? [String] ?? []
                self.followers = user["followers"] as? [String] ?? []
                //self.user.id = uid
            } else {
                return
            }
        }
    }
    
    func toggleLike(for recipeID: String) {
        if let likedRecipes = user.likedRecipes {
            if (likedRecipes.contains(recipeID)) {
                
            }
        }
        /*if user.likedRecipes.contains(recipeID) {
            // Unlike the recipe
            if let index = user.likedRecipes.firstIndex(of: recipeID) {
                user.likedRecipes.remove(at: index)
            }
        } else {
            // Like the recipe
            user.likedRecipes.append(recipeID)
        }*/
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

            let userRef = db.getFirestore().collection("users").document(id ?? "")
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

