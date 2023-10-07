//
//  ChatListView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 6.09.2023.
//

import Foundation
import SwiftUI

struct ChatListView: View {
    @StateObject var viewModel = ChatListViewModel()
    @State private var readyToNavigateToNewChat : Bool = false
    @State private var isModalPresented = false

    var body: some View {
        NavigationStack {
            Button(action: {
                //readyToNavigateToNewChat = true
                isModalPresented.toggle()
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .padding(.top, 3)
                    .padding(.trailing, 3)
                    .foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255))
                }
            List(viewModel.chatRooms) { chatRoom in
                NavigationLink(value: chatRoom) {
                    Text(chatRoom.lastMessage)
                }
                /*NavigationLink(destination: ChatView(viewModel: ChatViewModel(chatRoomID: ""))) {
                    VStack(alignment: .leading) {
                        Text(viewModel.chatRooms[0].id)
                        //Text(chatRoom.name).font(.headline)
                        //Text(chatRoom.lastMessage).font(.subheadline).foregroundColor(.gray)
                    }
                }*/
            }
            .onAppear(perform: viewModel.fetchChatRooms)
            //.navigationTitle("Chats")
            /*.navigationDestination(isPresented: $readyToNavigateToNewChat) {
                          NewChatView()
                      }*/
            .navigationDestination(for: ChatRoom.self) { value in
                //ChatView(viewModel: ChatViewModel(chatRoomID: value))
                ChatView(viewModel: ChatViewModel(chatRoom: value))
                //CameraView(recipeViewModel: viewModel, index: value)
            }
            .sheet(isPresented: $isModalPresented) {
                NewChatView()
                    }
        }
    }
}

struct Previews_ChatListViewView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
