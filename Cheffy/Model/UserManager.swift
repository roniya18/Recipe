//
//  CustomError.swift
//  Cheffy
//
//  Created by alkesh s on 13/05/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class UserManager : ObservableObject{
    
    static let shared = UserManager()
    private init() { }
    
    var image = ""
    var uiImage = UIImage()
    @Published var users = Users(image: UIImage() , name: "")
   
    func createUser(auth:AuthdataResultModel,name:String) async throws {
        var userData : [String:Any] = [
            "user_id" : auth.uid,
            "email" : auth.email as Any,
            "name" : name,
            "image" : image
            
        ]
        try await Firestore.firestore().collection("Users").document(auth.uid).setData(userData, merge: false)
    }
    
    func getUserData() async{
        
        let userId = AuthenticationModel.shared.getUserId()
        try await Firestore.firestore().collection("Users").document(userId!).getDocument(completion: { [self]snapshot, error in
            if error == nil {
                if let snapshot = snapshot{
                   let data = snapshot.data()
                    let path = data!["image"] as! String
                    print(path)
                    Task{
                        uiImage = try await ImagePicker().getImage(path: path)
                    }
                    
                    users = Users(image: uiImage, name: data?["name"] as! String)
                }
            }else{
                print(error?.localizedDescription)
            }
            print(users)
        })
        
    }
    
    func addFav(userId:String,recipeId:String) async throws {
        
        try await Firestore.firestore().collection("Users").document(userId).collection("favorite_recipe").document(recipeId).setData([:], merge: false)
    }
    
    func getFavRecipies() async throws {
        let authDataResult = try AuthenticationModel.shared.getUser()
        let recipeRef = RecipeViewModel.shared
        let snapshot = try await Firestore.firestore().collection("Users").document(authDataResult.uid).collection("favorite_recipe").getDocuments()
        
        for favRec in snapshot.documents{
            try await  recipeRef.getFavRecipe(recipeId: favRec.documentID)
        }
    }
}


