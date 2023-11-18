//
//  ProfileView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 12.07.2023.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct UserView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State var isLinkActive = false
    @State var readyToNavigate = false
    @Binding var selectedTab: Int
    let firebaseAuth = AuthManager.shared
    //@Binding var userState: Int
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                UserView16(userViewModel: userViewModel)
            } else {
                UserView15(userViewModel: userViewModel)
            }
        }
    }
}

@available(iOS 16.0, *)
struct UserView16: View {
    let firebaseAuth = AuthManager.shared
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    VStack(spacing: 0) {
                        LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)//.edgesIgnoringSafeArea(.top)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                        Rectangle()
                            .fill(Color(red: 21/255, green: 23/255, blue: 17/255)) // Change to any color you want.
                            .frame(width: geometry.size.width)
                    }.edgesIgnoringSafeArea(.top)
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 56/255, green: 56/255, blue: 56/255))
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                            firebaseAuth.signOut()
                                    }) {
                                        Image(systemName: "gearshape.fill")
                                            .font(.title)
                                            .padding(.top, 3)
                                            .padding(.trailing, 3)
                                            .foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255))
                                        }
                                }
                                HStack {
                                    VStack{
                                        if let profilePhoto = userViewModel.user.profilePhoto {
                                            Image(uiImage: profilePhoto)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                                                .background(.white)
                                                .clipShape(Circle())
                                        }
                                    }.padding(.leading)
                                    VStack{
                                        Text("\(userViewModel.user.firstName) \(userViewModel.user.lastName)")
                                        //Text("\(userViewModel.firstName ?? "") \(userViewModel.lastName ?? "")")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                        Text("@\(userViewModel.user.userName)")
                                        //Text("@\(userViewModel.userName ?? "")")
                                            .font(.subheadline)
                                            .foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255))
                                    }
                                    Spacer()
                                }
                                Divider()
                                    .padding(.horizontal)
                                HStack{
                                    Spacer()
                                    VStack {
                                        Text("Tarifler")
                                            .font(.subheadline)
                                            .foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255))
                                        Text("\(userViewModel.user.submittedRecipes.count)")
                                        //Text("\(userViewModel.submittedRecipes?.count ?? 0)")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    VStack {
                                        Text("Takipçi")
                                            .font(.subheadline)
                                            .foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255))
                                        Text("\(userViewModel.user.followers.count)")
                                        //Text("\(userViewModel.followers?.count ?? 0)")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    VStack {
                                        Text("Takip Edilen")
                                            .font(.subheadline)
                                            .foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255))
                                        Text("\(userViewModel.user.following.count)")
                                        //Text("\(userViewModel.following?.count ?? 0)")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                }
                                Spacer()
                            }
                            /*VStack {
                                Text("\(UIScreen.main.bounds.width) \(UIScreen.main.bounds.height)")
                                Text("\(geometry.size.width) \(geometry.size.height)")
                                Text("\(safeAreaInsets.top) \(safeAreaInsets.bottom)")
                            }*/
                        }.frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.25)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.25 - safeAreaInsets.top)
                        LazyVGrid(columns: Array(repeating: .init(), count: 3), spacing: 20) {
                            ForEach(userViewModel.user.submittedRecipes, id: \.self) { item in
                            //ForEach(userViewModel.user.submittedRecipes ?? [], id: \.self) { item in
                                            Text("\(item)")
                                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                        }
                                    }
                    }
                }
                /*VStack {
                    if let profilePicture = userViewModel.user.profilePicture {
                        Image(uiImage: profilePicture)
                            .resizable()
                            .frame(width: 150, height: 150)
                    }
                    Text("Hello, \(userViewModel.user.firstName) \(userViewModel.user.lastName) \(userViewModel.testName)!")
                    /*NavigationLink(destination: RegisterView(), isActive: $isLinkActive) {
                        Button(action: {
                            self.isLinkActive = true
                            userViewModel.signOut()
                        }) {
                            Text("Sign Out")
                        }
                    }*/
                    Button("Sign Out 1") {
                        userViewModel.signOut()
                        //userViewModel.checkLoggedIn()
                        selectedTab = 4
                        //print(selectedTab)
                    }
                    
                    /*Button("Sign Out") {
                    //Code here before changing the bool value
                        readyToNavigate = true
                    }
                    .navigationTitle("Register")
                    .navigationDestination(isPresented: $readyToNavigate) {
                        RegisterView()
                    }*/
                }*/
            }
        }.onAppear {
            //recipeViewModel.fetchRecipes(count: 5)
            //userViewModel.fetchUserData()
            //let _ = print("\(userViewModel.email)111111111111111111111111")
        }
    }
    
}

struct UserView15: View {
    let firebaseAuth = AuthManager.shared
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    VStack(spacing: 0) {
                        LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)//.edgesIgnoringSafeArea(.top)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                        Rectangle()
                            .fill(Color(red: 21/255, green: 23/255, blue: 17/255)) // Change to any color you want.
                            .frame(width: geometry.size.width)
                    }.edgesIgnoringSafeArea(.top)
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 56/255, green: 56/255, blue: 56/255))
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                            firebaseAuth.signOut()
                                    }) {
                                        Image(systemName: "gearshape.fill")
                                            .font(.title)
                                            .padding(.top, 3)
                                            .padding(.trailing, 3)
                                            .foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255))
                                        }
                                }
                                HStack {
                                    VStack{
                                        if let profilePhoto = userViewModel.user.profilePhoto {
                                            Image(uiImage: profilePhoto)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                                                .background(.white)
                                                .clipShape(Circle())
                                        }
                                    }.padding(.leading)
                                    VStack{
                                        Text("\(userViewModel.user.firstName) \(userViewModel.user.lastName)")
                                        //Text("\(userViewModel.firstName ?? "") \(userViewModel.lastName ?? "")")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                        Text("@\(userViewModel.user.userName)")
                                        //Text("@\(userViewModel.userName ?? "")")
                                            .font(.subheadline)
                                            .foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255))
                                    }
                                    Spacer()
                                }
                                Divider()
                                    .padding(.horizontal)
                                HStack{
                                    Spacer()
                                    VStack {
                                        Text("Tarifler")
                                            .font(.subheadline)
                                            .foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255))
                                        Text("\(userViewModel.user.submittedRecipes.count)")
                                        //Text("\(userViewModel.submittedRecipes?.count ?? 0)")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    VStack {
                                        Text("Takipçi")
                                            .font(.subheadline)
                                            .foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255))
                                        Text("\(userViewModel.user.followers.count)")
                                        //Text("\(userViewModel.followers?.count ?? 0)")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    VStack {
                                        Text("Takip Edilen")
                                            .font(.subheadline)
                                            .foregroundColor(Color(red: 159/255, green: 159/255, blue: 159/255))
                                        Text("\(userViewModel.user.following.count)")
                                        //Text("\(userViewModel.following?.count ?? 0)")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                }
                                Spacer()
                            }
                            /*VStack {
                                Text("\(UIScreen.main.bounds.width) \(UIScreen.main.bounds.height)")
                                Text("\(geometry.size.width) \(geometry.size.height)")
                                Text("\(safeAreaInsets.top) \(safeAreaInsets.bottom)")
                            }*/
                        }.frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.25)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.25 - safeAreaInsets.top)
                        LazyVGrid(columns: Array(repeating: .init(), count: 3), spacing: 20) {
                            ForEach(userViewModel.user.submittedRecipes, id: \.self) { item in
                            //ForEach(userViewModel.user.submittedRecipes ?? [], id: \.self) { item in
                                            Text("\(item)")
                                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                        }
                                    }
                    }
                }
                /*VStack {
                    if let profilePicture = userViewModel.user.profilePicture {
                        Image(uiImage: profilePicture)
                            .resizable()
                            .frame(width: 150, height: 150)
                    }
                    Text("Hello, \(userViewModel.user.firstName) \(userViewModel.user.lastName) \(userViewModel.testName)!")
                    /*NavigationLink(destination: RegisterView(), isActive: $isLinkActive) {
                        Button(action: {
                            self.isLinkActive = true
                            userViewModel.signOut()
                        }) {
                            Text("Sign Out")
                        }
                    }*/
                    Button("Sign Out 1") {
                        userViewModel.signOut()
                        //userViewModel.checkLoggedIn()
                        selectedTab = 4
                        //print(selectedTab)
                    }
                    
                    /*Button("Sign Out") {
                    //Code here before changing the bool value
                        readyToNavigate = true
                    }
                    .navigationTitle("Register")
                    .navigationDestination(isPresented: $readyToNavigate) {
                        RegisterView()
                    }*/
                }*/
            }
        }.onAppear {
            //recipeViewModel.fetchRecipes(count: 5)
            //userViewModel.fetchUserData()
            //let _ = print("\(userViewModel.email)111111111111111111111111")
        }
    }
    
}
