//
//  MainView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 11.08.2023.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    //@ObservedObject var userViewModel = UserViewModel()
    //var userViewModel = UserViewModel(user: User(firstName: "", lastName: "", email: "", userName: "", profilePicture: UIImage(), submittedRecipes: [], likedRecipes: [], following: [], followers: [], id: ""))
    @StateObject var userViewModel = UserViewModel()
    @ObservedObject var recipeViewModel = RecipeViewModel.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RecipeReelView(userViewModel: userViewModel).tabItem {
                if (selectedTab == 0) {
                    Image(systemName: "house").environment(\.symbolVariants, .fill) }
                else {
                    Image(systemName: "house").environment(\.symbolVariants, .none)
                }
            }.tag(0)
            ExploreView().tabItem {
                if (selectedTab == 1) {
                    Image(systemName: "magnifyingglass.circle").environment(\.symbolVariants, .fill) }
                else {
                    Image(systemName: "magnifyingglass.circle").environment(\.symbolVariants, .none)
                }
            }.tag(1)
            RecipeAddView().tabItem {
                if (selectedTab == 2) {
                    Image(systemName: "frying.pan").environment(\.symbolVariants, .fill) }
                else {
                    Image(systemName: "frying.pan").environment(\.symbolVariants, .none)
                }
            }.tag(2)
            ChatListView().tabItem {
                if (selectedTab == 3) {
                    Image(systemName: "message").environment(\.symbolVariants, .fill) }
                else {
                    Image(systemName: "message").environment(\.symbolVariants, .none)
                }
            }.tag(3)
            UserView(userViewModel: userViewModel, selectedTab: .constant(4)).tabItem {
                if (selectedTab == 4) {
                    Image(systemName: "person").environment(\.symbolVariants, .fill) }
                else {
                    Image(systemName: "person").environment(\.symbolVariants, .none)
                }
            }.tag(4)
            /*ApprovalView().tabItem {
                if (selectedTab == 5) {
                    Image(systemName: "clock").environment(\.symbolVariants, .fill) }
                else {
                    Image(systemName: "clock").environment(\.symbolVariants, .none)
                }
            }.tag(5)*/
            /*if (!userViewModel.isLoggedIn)
             {
             RegisterView().tabItem {
             Image(systemName: "message").environment(\.symbolVariants, .fill) }.tag(4)
             }
             else {
             //userViewModel.fetchUserData()
             UserView(userViewModel: userViewModel).tabItem {
             Image(systemName: "person").environment(\.symbolVariants, .fill) }.tag(4)
             }*/
            //LoginView(selectedTab: $selectedTab).tabItem { Text("Test") }.tag(5)
            /*CameraView().tabItem {
             Text("CameraTest")
             }.tag(6)*/
            //RegisterView().tabItem { Image(systemName: "face.smiling") }.tag(4)
        }.accentColor(.gray)
            .onAppear {
                recipeViewModel.fetchRecipes(count: 3)
                userViewModel.fetchUserData()
                //let _ = print("\(userViewModel.email)111111111111111111111111")
            }
                //userViewModel.fetchUserData()
                // Code to execute when the ProfileView appears
                //userViewModel.checkLoggedIn()
                //print(Auth.auth().currentUser)
                //print(registerViewModel.isLoggedIn)
    }
}

