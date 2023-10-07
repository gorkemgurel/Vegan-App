//
//  LoginViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 13.07.2023.
//

import Foundation

class LoginViewModel: ObservableObject {
    let firebaseAuth = AuthManager.shared
    @Published var email: String = ""
    @Published var password: String = ""
    
    func login() {
        firebaseAuth.getAuth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Failed to sign in with error: \(error.localizedDescription)")
                return
            }
            self.firebaseAuth.checkLoggedIn()
        }
    }
}
