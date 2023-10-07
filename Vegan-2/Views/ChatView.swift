//
//  ChatRoomView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 6.09.2023.
//

import Foundation
import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    @State private var messageText: String = ""

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                /*List(viewModel.messages, id: \.id) { message in
                    Group {
                        if message.senderID == AuthManager.shared.getAuth().currentUser?.uid {
                            // Current user's message UI, typically aligned to the right
                            HStack {
                                Spacer()
                                Text(message.content)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        } else {
                            // Other user's message UI, typically aligned to the left
                            HStack {
                                Text(message.content)
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .transition(.move(edge: .leading).combined(with: .opacity))
                                Spacer()
                            }
                        }
                    }.onAppear {
                        print("ScrollView appeared!")
                        scrollView.scrollTo(viewModel.messages.last?.id)
                        print(viewModel.messages.last?.id)
                    }
                    .onChange(of: viewModel.messages.count) { newCount in
                        print("Message count changed to: \(newCount)")
                        print("Last message ID:", viewModel.messages.last?.id)
                        //scrollView.scrollTo(viewModel.messages.last?.id)
                        scrollView.scrollTo(viewModel.messages.count - 1)
                        //scrollView.scrollTo("uuxirfXaUNizxpJn3vVK")
                        //scrollView.scrollTo(message.id)
                    }
                }*/
                ScrollView {
                    VStack {
                        ForEach (viewModel.messages, id: \.id) { message in
                            if message.senderID == AuthManager.shared.getAuth().currentUser?.uid {
                                // Current user's message UI, typically aligned to the right
                                HStack {
                                    Spacer()
                                    Text(message.content)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                        .transition(.move(edge: .trailing).combined(with: .opacity))
                                }
                            } else {
                                // Other user's message UI, typically aligned to the left
                                HStack {
                                    Text(message.content)
                                        .padding()
                                        .background(Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                        .transition(.move(edge: .leading).combined(with: .opacity))
                                    Spacer()
                                }
                            }
                        }
                    }
                }.onAppear {
                    print("ScrollView appeared!")
                    //scrollView.scrollTo(viewModel.messages.last!.id)
                    //print(viewModel.messages.last!.id)
                }
                .onChange(of: viewModel.messages.count) { newCount in
                    print("Message count changed to: \(newCount)")
                    print("Last message ID:", viewModel.messages.last!.id)
                    scrollView.scrollTo(viewModel.messages.last!.id)
                    //scrollView.scrollTo(viewModel.messages.count - 1)
                    //scrollView.scrollTo("uuxirfXaUNizxpJn3vVK")
                }
            }
            

            HStack {
                TextField("Enter message", text: $messageText)
                    .onChange(of: messageText) { newValue in
                        viewModel.message.content = newValue
                    }
                Button("Send") {
                    withAnimation {
                        viewModel.sendMessage(receiverID: viewModel.receiverID)
                        messageText = ""
                    }
                }
            }
        }
    }
}

