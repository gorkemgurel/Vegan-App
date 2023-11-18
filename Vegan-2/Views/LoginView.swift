//
//  LoginView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 12.07.2023.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @ObservedObject var loginViewModel = LoginViewModel()
    @Binding var selectedTab: Int
    
    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                LoginView16(loginViewModel: loginViewModel, selectedTab: $selectedTab)
            } else {
                LoginView15(loginViewModel: loginViewModel, selectedTab: $selectedTab)
            }
        }
    }
}

@available(iOS 16.0, *)
struct LoginView16: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Loginn")
                TextField("E-Mail", text: $loginViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.blue)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                SecureField("Password", text: $loginViewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.blue)
                        .textContentType(.password)

                Button("Login") {
                    loginViewModel.login()
                    selectedTab = 1
                }
                
                
            }
        }
    }
}

struct LoginView15: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Loginn")
                TextField("E-Mail", text: $loginViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.blue)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                SecureField("Password", text: $loginViewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.blue)
                        .textContentType(.password)

                Button("Login") {
                    loginViewModel.login()
                    selectedTab = 1
                }
                
                
            }
        }
    }
}
