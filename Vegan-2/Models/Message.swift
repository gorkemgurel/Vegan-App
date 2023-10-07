//
//  Message.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 6.09.2023.
//

import Foundation

struct Message: Identifiable {
    var id: String = ""    
    var content: String = ""
    var senderID: String = ""
    var timestamp: Date = Date()
}
