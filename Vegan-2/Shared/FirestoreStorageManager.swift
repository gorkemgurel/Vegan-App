//
//  FirestoreStorageManager.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 15.08.2023.
//

import Foundation
import FirebaseStorage

class FirebaseStorageManager {
    // Singleton instance
    static let shared = FirebaseStorageManager()
    
    private let storage: Storage
    
    private init() {
        storage = Storage.storage()
    }
    
    func getStorage() -> Storage {
        return storage
    }
}
