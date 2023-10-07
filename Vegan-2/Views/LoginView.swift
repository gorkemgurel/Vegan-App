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
    //@Binding var userState: Int
    @State var isLinkActive = false
    //var selectedTab: Binding<Int>
    //@StateObject var loginViewModel = LoginViewModel()
    
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
                    //print(selectedTab)
                }
                
                
            }
        }
    }
}

struct Previews_LoginView_Previews: PreviewProvider {
    @StateObject var loginViewModel = LoginViewModel()
    static var previews: some View {
        LoginView(selectedTab: .constant(4))
    }
}
