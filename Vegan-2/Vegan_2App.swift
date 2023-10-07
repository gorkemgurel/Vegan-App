//
//  Vegan_2App.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 21.06.2023.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
    
    //@ObservedObject var firebaseAuth = AuthManager.shared
        func application(_ application: UIApplication,
                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
        FirebaseApp.configure()
      
        let db = Firestore.firestore()
        AuthManager.shared.checkLoggedIn()
      
        print(db)
      
        return true
  }
    
    
}

@main
struct Vegan_2App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
