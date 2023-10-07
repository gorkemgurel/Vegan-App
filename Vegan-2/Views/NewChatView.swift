//
//  NewChatView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 8.09.2023.
//

import Foundation
import SwiftUI

struct NewChatView: View {
    @ObservedObject var viewModel = NewChatViewModel()
    //var newChatRoom = ChatRoom()
    //@ObservedObject var viewModel = ChatViewModel(chatRoom: ChatRoom())
    @State private var messageText: String = ""
    @State private var usernameText: String = ""
    
    var body: some View {
        VStack {
            TextField("Kullanıcı Adı", text: $usernameText)
                .onChange(of: usernameText) { newValue in
                    viewModel.receiverUsername = newValue
                }
                .padding()
            TextField("Mesaj", text: $messageText)
                .onChange(of: messageText) { newValue in
                    viewModel.message = newValue
                }
                .padding()
            Button(action: {
                viewModel.sendFirstMessage()
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.title)
                    .padding(.top, 3)
                    .padding(.trailing, 3)
                    .foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255))
            }
            Spacer()
        }
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView()
    }
}
