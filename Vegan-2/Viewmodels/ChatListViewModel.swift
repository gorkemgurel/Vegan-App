//
//  ChatListViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 8.09.2023.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class ChatListViewModel: ObservableObject {
    @Published var chatRooms: [ChatRoom] = []
    
    private let db = FirestoreManager.shared
    private let firebaseAuth = AuthManager.shared
    private var listener: ListenerRegistration?
    
    func fetchChatRooms() {
        
        guard let uid = firebaseAuth.getAuth().currentUser?.uid else {
            return
        }
            // Make sure to remove any existing listeners
        listener?.remove()

        listener = db.getFirestore().collection("chats")
                .whereField("participants", arrayContains: uid)
                .order(by: "lastUpdated", descending: true)
                .limit(to: 25)
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No chat rooms found: \(String(describing: error))")
                        return
                    }
                    
                    self.chatRooms = documents.compactMap { (queryDocumentSnapshot) -> ChatRoom? in
                        // Convert your document data to your ChatRoom model here
                        // This depends on how your ChatRoom model is structured
                        
                        // Example
                        let data = queryDocumentSnapshot.data()
                        let id = queryDocumentSnapshot.documentID
                        let lastUpdated = (data["lastUpdated"] as? Timestamp)?.dateValue() ?? Date()
                        //let lastUpdated = data["lastUpdated"] as? Timestamp)?.dateValue() ?? Date()
                        let lastMessage = data["lastMessage"] as? String ?? ""
                        let participants = data["participants"] as? [String] ?? []
                        // ... fetch other properties

                        return ChatRoom(id: id, lastUpdated: lastUpdated, lastMessage: lastMessage, participants: participants)
                    }
                }
        }
}
