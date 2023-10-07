//
//  NewChatViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 8.09.2023.
//

import Foundation
import FirebaseFirestore

class NewChatViewModel: ObservableObject {
    
    @Published var chatRooms: [ChatRoom] = []
    
    let firebaseAuth = AuthManager.shared
    let db = FirestoreManager.shared
    @Published var receiverUsername: String = ""
    @Published var message: String = ""
    
    //private var listener: ListenerRegistration?
    
    func getUIDForUsername(username: String, completion: @escaping (String?) -> Void) {
        db.getFirestore().collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error checking username: \(error)")
                    completion(nil)
                    return
                }
                
                if let documents = snapshot?.documents, !documents.isEmpty {
                    let userUID = documents.first?.documentID
                    completion(userUID)
                } else {
                    completion(nil)
                }
            }
    }

    
    /*func checkUsernameExists(username: String, completion: @escaping (Bool) -> Void) {
        db.getFirestore().collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error checking username: \(error)")
                    completion(false)
                    return
                }
                
                if let documents = snapshot?.documents, !documents.isEmpty {
                    completion(true)
                } else {
                    completion(false)
                }
            }
    }*/
    
    func sendFirstMessage() {
        /*checkUsernameExists(username: receiverUsername) { exists in
            if exists {
                self.sendMessage()
            } else {
                print("Username doesn't exist!")
            }
        }*/
        getUIDForUsername(username: receiverUsername) { uid in
            if let userID = uid {
                self.sendMessage(receiverID: userID)
            } else {
                print("\(self.receiverUsername) does not exist.")
            }
        }
    }
    

    // Fetch the list of chat rooms from Firebase (pseudo-code)
    func sendMessage(receiverID: String) {
        if let senderID = firebaseAuth.getAuth().currentUser?.uid {
            let roomID = generateChatRoomID(for: senderID, and: receiverID)
            let chatReference = db.getFirestore().collection("chats").document(roomID)
            
            // Send the message
            let messageData: [String: Any] = [
                "content": message,
                "senderID": senderID,
                "timestamp": FieldValue.serverTimestamp() // Assuming you might want a timestamp for the message itself
            ]
            chatReference.collection("messages").addDocument(data: messageData)
            
            // Always update lastUpdated and participants
            let updateData: [String: Any] = [
                "lastMessage": message,
                "lastUpdated": FieldValue.serverTimestamp(),
                "participants": [senderID, receiverID]
            ]
            chatReference.setData(updateData, merge: true)
        }
    }
    
    /*func fetchChatRooms() {
            // Make sure to remove any existing listeners
        db.listener?.remove()

        db.listener = db.getFirestore().collection("groups")
                .whereField("participants", arrayContains: userID)
                .orderBy("lastUpdated", descending: true)
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
                        let chatID = data["chatID"] as? String ?? ""
                        let lastUpdated = (data["lastUpdated"] as? Timestamp)?.dateValue() ?? Date()
                        // ... fetch other properties

                        return ChatRoom(chatID: chatID, lastUpdated: lastUpdated)
                    }
                }
        }*/
    
    private func generateChatRoomID(for user1: String, and user2: String) -> String {
        return [user1, user2].sorted().joined(separator: "_")
    }
}
