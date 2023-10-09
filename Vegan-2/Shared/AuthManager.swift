//
//  FirebaseAuth.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 14.07.2023.
//

import FirebaseAuth
import FirebaseFirestore

class AuthManager: ObservableObject {
    @Published var isUserAuthenticated: Bool = false
    //private let db = FirestoreManager.shared
    
    static let shared = AuthManager()
    
    private let auth: Auth
    
    private init() {
        auth = Auth.auth()
    }
    
    func getAuth() -> Auth {
        return auth
    }
    
    func signOut() {
        do {
            try getAuth().signOut()
            checkLoggedIn()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    
    func checkLoggedIn() {
        if let _ = auth.currentUser {
            // User is already logged in
            isUserAuthenticated = true
        } else {
            // User is not logged in
            isUserAuthenticated = false
        }
    }
    
    /*func fetchCurrentUserDocument() {
        if isUserAuthenticated, let userID = auth.currentUser?.uid {
            currentUserDocument = db.getFirestore().collection("users").document(userID)
        }
    }*/
}
