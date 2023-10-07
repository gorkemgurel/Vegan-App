//
//  ChatRoom.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 6.09.2023.
//

import Foundation

/*struct ChatRoom: Identifiable, Hashable {
    var id: String // Chat room's unique ID
    //var name: String // Name of the chat room, for one-on-one could be the other user's name
    //var lastMessage: String // The most recent message in this chat room
    var lastUpdated: Date
    var lastMessage: String
}*/

struct ChatRoom: Identifiable, Hashable {
    var id: String = "" // Chat room's unique ID
    //var name: String // Name of the chat room, for one-on-one could be the other user's name
    //var lastMessage: String // The most recent message in this chat room
    var lastUpdated: Date = Date()
    var lastMessage: String = ""
    var participants: [String] = []
}
