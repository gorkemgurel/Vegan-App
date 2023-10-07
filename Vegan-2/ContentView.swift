//
//  ContentView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 21.06.2023.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct ContentView: View {
    //let images: [Image] = [Image("Image 1"), Image("Image 2"), Image("Image")] // Replace with your images
    //@State private var selectedTab = 0
    //@State private var isLoggedIn = false
    //@State private var isLoggedIn = false
    //@ObservedObject var registerViewModel = RegisterViewModel()
    //@ObservedObject var userViewModel = UserViewModel()
    //let firebaseAuth = AuthManager.shared.getAuth()
    /*var userViewModel = UserViewModel(user: User(firstName: "Şevval", lastName: "Alsancak", email: "sevvalalsancak@icloud.com", userName: "sevvalalsancak", profilePicture: UIImage(), submittedRecipes: [], likedRecipes: [], following: ["",""], followers: ["",""]))*/
    
    @ObservedObject var firebaseAuth = AuthManager.shared
    //@ObservedObject var recipeViewModel = RecipeViewModel.shared
    
    //@State private var currentUser: FirebaseAuth.User?
    
    //@State private var path: [Int] = []
    
    var body: some View {
        //MainView()
        //RecipeReelView(userViewModel: UserViewModel())
        /*if (firebaseAuth.currentUser != nil) {
            MainView()
        }*/
        if (firebaseAuth.isUserAuthenticated) {
        //if (firebaseAuth.checkLoggedIn()) {
            MainView()
        }
        else {
            RegisterView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
