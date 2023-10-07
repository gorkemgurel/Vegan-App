//
//  FirestoreManager.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 14.07.2023.
//

import FirebaseFirestore

class FirestoreManager {
    static let shared = FirestoreManager()
    private let firebaseAuth = AuthManager.shared
    private let db: Firestore
    
    var listener: ListenerRegistration?
    
    private init() {
        db = Firestore.firestore()
        // Additional configuration if needed
    }
    
    func getFirestore() -> Firestore {
        return db
    }
}
