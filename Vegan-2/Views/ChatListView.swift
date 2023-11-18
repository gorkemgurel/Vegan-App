//
//  ChatListView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 6.09.2023.
//

import Foundation
import SwiftUI

struct ChatListView: View {
    @StateObject var chatListViewModel = ChatListViewModel()
    @State private var readyToNavigateToNewChat: Bool = false
    @State private var isModalPresented = false
    
    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                ChatListView16(chatListViewModel: chatListViewModel)
            } else {
                ChatListView15(chatListViewModel: chatListViewModel)
            }
        }
    }

    
}

@available(iOS 16.0, *)
struct ChatListView16: View {
    @StateObject var chatListViewModel: ChatListViewModel
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
            List(chatListViewModel.chatRooms) { chatRoom in
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
            .onAppear(perform: chatListViewModel.fetchChatRooms)
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

struct ChatListView15: View {
    @StateObject var chatListViewModel: ChatListViewModel
    @State private var isModalPresented = false
    
    var body: some View {
        NavigationView {
            ZStack {
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
                Image("house")
                    .resizable()
                    .frame(width: 200, height: 200)
                List(chatListViewModel.chatRooms) { chatRoom in
                    NavigationLink(destination: ChatView(viewModel: ChatViewModel(chatRoom: chatRoom))) {
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
                .onAppear(perform: chatListViewModel.fetchChatRooms)
                //.navigationTitle("Chats")
                /*.navigationDestination(isPresented: $readyToNavigateToNewChat) {
                              NewChatView()
                          }*/
                .sheet(isPresented: $isModalPresented) {
                    NewChatView()
                        }
            }
            .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
            
        }
    }
}
