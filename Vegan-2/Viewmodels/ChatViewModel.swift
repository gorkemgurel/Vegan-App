//
//  ChatViewModel.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 6.09.2023.
//

import Foundation
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    let firebaseAuth = AuthManager.shared
    
    @Published var messages: [Message] = []
    @Published var message: Message = Message()
    
    var receiverUsername: String = ""
    var receiverID: String = ""
    
    private var db = FirestoreManager.shared
    private var chatReference: CollectionReference?
    var chatRoom: ChatRoom
    
    var content: String {
        get { message.content }
        set { message.content = newValue }
    }
    
    var senderID: String {
        get { message.senderID }
        set { message.senderID = newValue }
    }
    
    var timestamp: Date {
        get { message.timestamp }
        set { message.timestamp = newValue }
    }

    init(chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
        receiverID = chatRoom.participants.first(where: { $0 != firebaseAuth.getAuth().currentUser?.uid }) ?? ""
        let _ = print(receiverID)
        self.chatReference = db.getFirestore().collection("chats").document(chatRoom.id).collection("messages")
        observeMessages()
    }

    private func observeMessages() {
        chatReference?.order(by: "timestamp", descending: false).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching messages: \(String(describing: error))")
                return
            }

            self.messages = documents.compactMap { queryDocumentSnapshot -> Message? in
                let data = queryDocumentSnapshot.data()
                let content = data["content"] as? String ?? ""
                let senderID = data["senderID"] as? String ?? ""
                let timestamp = data["timestamp"] as? Timestamp
                let date = timestamp?.dateValue() ?? Date()
                let id = queryDocumentSnapshot.documentID
                return Message(id: id, content: content, senderID: senderID, timestamp: date)
            }
        }
    }

    
    /*func sendFirstMessage() {
        /*checkUsernameExists(username: receiverUsername) { exists in
            if exists {
                self.sendMessage()
            } else {
                print("Username doesn't exist!")
            }
        }*/
        getUIDForUsername(username: receiverUsername) { uid in
            if let receiverID = uid {
                self.chatRoom.id = self.generateChatRoomID(for: self.firebaseAuth.getAuth().currentUser!.uid, and: receiverID)
                //self.receiverID = receiverID
                self.sendMessage(receiverID: receiverID)
            } else {
                print("\(self.receiverUsername) does not exist.")
            }
        }
    }*/
    
    func sendMessage(receiverID: String) {
        if let senderID = firebaseAuth.getAuth().currentUser?.uid {
            //let roomID = generateChatRoomID(for: senderID, and: receiverID)
            let chatReference = db.getFirestore().collection("chats").document(chatRoom.id)
            
            // Send the message
            let messageData: [String: Any] = [
                "content": message.content,
                "senderID": senderID,
                "timestamp": FieldValue.serverTimestamp() // Assuming you might want a timestamp for the message itself
            ]
            chatReference.collection("messages").addDocument(data: messageData)
            
            // Always update lastUpdated and participants
            let updateData: [String: Any] = [
                "lastMessage": message.content,
                "lastUpdated": FieldValue.serverTimestamp(),
                "participants": [senderID, receiverID]
            ]
            chatReference.setData(updateData, merge: true)
        }
    }
    
    /*func getUIDForUsername(username: String, completion: @escaping (String?) -> Void) {
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
    }*/
    
    /*private func generateChatRoomID(for user1: String, and user2: String) -> String {
        return [user1, user2].sorted().joined(separator: "_")
    }*/

    /*func sendMessage(content: String, senderID: String) {
        let data: [String: Any] = [
            "content": content,
            "senderID": senderID,
            "timestamp": Timestamp(date: Date())
        ]
        chatReference?.addDocument(data: data)
    }*/
}

