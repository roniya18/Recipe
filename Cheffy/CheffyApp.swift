//
//  CheffyApp.swift
//  Cheffy
//
//  Created by alkesh s on 09/05/23.
//

import SwiftUI
import Firebase

@main
struct CheffyApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("LOGIN_STATUS") var LOGIN_STATUS = false
    
    
    var body: some Scene {
        WindowGroup {
            if LOGIN_STATUS {
               TabBarView()
                    .onAppear(){
                        Task{
                            try await RecipeViewModel.shared.getRecipe()
                            try await UserManager.shared.getFavRecipies()
                        }
                    }
            }
            else{
                    LoginView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
