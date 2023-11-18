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
    /*@ObservedObject var recipeStore = RecipeStore()
    @StateObject var userViewModel = UserViewModel()
    @ObservedObject var recipeReelViewModel = RecipeReelViewModel(recipeStore: recipeStore)*/
    
    /*var recipeStore: RecipeStore
    var userViewModel: UserViewModel
    var recipeReelViewModel: RecipeReelViewModel
    
    init() {
        recipeStore = RecipeStore()
        userViewModel = UserViewModel()
        recipeReelViewModel = RecipeReelViewModel(recipeStore: recipeStore)
    }*/
    
        @ObservedObject var userViewModel: UserViewModel
        @ObservedObject var reelViewModel: ReelViewModel
        @ObservedObject var exploreViewModel: ExploreViewModel
        @ObservedObject var recipeAddViewModel: RecipeAddViewModel
        
        init() {
            self.userViewModel = UserViewModel()
            self.reelViewModel = ReelViewModel()
            self.exploreViewModel = ExploreViewModel()
            self.recipeAddViewModel = RecipeAddViewModel()
            if #available(iOS 15, *) {
                let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
                   tabBarAppearance.configureWithOpaqueBackground()
                    UITabBar.appearance().standardAppearance = tabBarAppearance
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ReelView(reelViewModel: reelViewModel, userViewModel: userViewModel).tabItem {
                if (selectedTab == 0) {
                    VStack {
                        Text("")
                        Image("house.fill")
                    }
                }
                else {
                    VStack {
                        Text("")
                        Image("house")
                    }
                }
            }.tag(0)
            ExploreView(exploreViewModel: exploreViewModel).tabItem {
                if (selectedTab == 1) {
                    VStack {
                        Text("")
                        Image("magnifier.fill")
                    }
                }
                else {
                    VStack {
                        Text("")
                        Image("magnifier")
                    }
                }
            }.tag(1)
            RecipeAddView(recipeAddViewModel: recipeAddViewModel).tabItem {
                if (selectedTab == 2) {
                    VStack {
                        Text("")
                        Image("pan.fill")
                    }
                }
                else {
                    VStack {
                        Text("")
                        Image("pan")
                    }
                }
            }.tag(2)
            ChatListView().tabItem {
                if (selectedTab == 3) {
                    VStack {
                        Text("")
                        Image("message.fill")
                    }
                }
                else {
                    VStack {
                        Text("")
                        Image("message")
                    }
                }
            }.tag(3)
            UserView(userViewModel: userViewModel, selectedTab: .constant(4)).tabItem {
                if (selectedTab == 4) {
                    VStack {
                        Text("")
                        Image("person.fill")
                    }
                }
                else {
                    VStack {
                        Text("")
                        Image("person")
                    }
                }
            }.tag(4)
            /*ReelView(reelViewModel: reelViewModel, userViewModel: userViewModel).tabItem {
                if (selectedTab == 0) {
                    Image(systemName: "house").environment(\.symbolVariants, .fill) }
                else {
                    Image(systemName: "house").environment(\.symbolVariants, .none)
                }
            }.tag(0)
            ExploreView(exploreViewModel: exploreViewModel).tabItem {
                if (selectedTab == 1) {
                    Image(systemName: "magnifyingglass.circle").environment(\.symbolVariants, .fill) }
                else {
                    Image(systemName: "magnifyingglass.circle").environment(\.symbolVariants, .none)
                }
            }.tag(1)
            RecipeAddView(recipeAddViewModel: recipeAddViewModel).tabItem {
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
            }.tag(4)*/
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
                reelViewModel.fetchRecipesForReels(count: 3)
                exploreViewModel.fetchRecipesForExplore(count: 9)
                //recipeStore.fetchRecipes(count: 3)
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

