//
//  RegisterView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 12.07.2023.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct RegisterView: View {
    @ObservedObject var registerViewModel = RegisterViewModel()
    //@StateObject var userViewModel = UserViewModel()
    @State var isLinkActive = false
    @State var readyToNavigate = false
    
    //@Binding var currentUser: FirebaseAuth.User?
    
    @State private var path: [Int] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("First Name", text: $registerViewModel.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.blue)
                        .autocapitalization(.words)
                        .textContentType(.givenName)
                TextField("Last Name", text: $registerViewModel.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.blue)
                        .autocapitalization(.words)
                        .textContentType(.familyName)
                TextField("Username", text: $registerViewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.blue)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                TextField("E-Mail", text: $registerViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.blue)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                SecureField("Password", text: $registerViewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.blue)
                        .textContentType(.password)
                /*Button("Register") {
                    registerViewModel.register(email: registerViewModel.email, password: registerViewModel.password) { result in
                        switch result {
                        case .success(let authResult):
                            print(authResult)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }*/
                Button("Register") {
                    registerViewModel.register()
                }
                
                Button("Login") {
                //Code here before changing the bool value
                    readyToNavigate = true
                }
                .navigationTitle("Register")
                .navigationDestination(isPresented: $readyToNavigate) {
                    LoginView(selectedTab: .constant(4))
                }
                

                
                /*NavigationLink(destination: LoginView(selectedTab: .constant(4)), isActive: $isLinkActive) {
                    Button(action: {
                        self.isLinkActive = true
                    }) {
                        Text("Login")
                    }
                }*/
            }
        }
    }
}

struct Previews_RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
