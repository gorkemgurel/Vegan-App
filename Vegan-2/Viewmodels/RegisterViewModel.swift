//
//  RegisterViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 13.07.2023.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    
    //let firebaseAuth = AuthManager.shared.getAuth()
    let firebaseAuth = AuthManager.shared
    let db = FirestoreManager.shared.getFirestore()
    
    //let db = Firestore.firestore()
    
    /*func register(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(authResult))
            }
        }
    }*/
    
    /*func register(firstName: String, lastName: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
          // ...
        }
        db.collection("users").addDocument(data: [
            "firstName": firstName,
            "lastName": lastName,
            "email": self.email
        ])
    }*/
    
    func register() {
        firebaseAuth.getAuth().createUser(withEmail: email, password: password) { [self] authResult, error in
            if let authResult = authResult {
                // User registration successful
                let uid = authResult.user.uid
                      
                // Create a document in Firestore with the same UID
                db.collection("users").document(uid).setData([
                    "firstName": firstName,
                    "lastName": lastName,
                    "username": username,
                    "email": email
                    ]) { error in
                        if let error = error {
                            // Handle Firestore document creation error
                            print("Firestore document creation error: \(error)")
                        } else {
                            self.firebaseAuth.checkLoggedIn()
                            // User document created successfully
                            print("User document created successfully")
                        }
                    }
            }
        }
        /*db.collection("users").addDocument(data: [
            "firstName": firstName,
            "lastName": lastName,
            "email": email
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }*/
    }
}
