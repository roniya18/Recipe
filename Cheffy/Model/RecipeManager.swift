//
//  RecipeManager.swift
//  Cheffy
//
//  Created by alkesh s on 19/05/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


@MainActor
class RecipeViewModel: ObservableObject{
    
    
    static let shared = RecipeViewModel()
    private init() { }
    
    
    let imagePicker = ImagePicker()
    let userManager = AuthenticationModel.shared
    
    @Published var recipeList = [Recipe]()
    @Published var favRecipieList = [Recipe]()
    
    
    @Published var image = ""
    @Published var recipeName = ""
    @Published var category = "Breakfast"
    @Published var description = ""
    @Published var ingrediants = ""
    
    
    let db = Firestore.firestore()
    
    func addRecipe() throws{
        let doc = db.collection("recipe").document()
        let docId = doc.documentID
        
        let userId = try userManager.getUser().uid
        
        
        let recipe : [String:Any] = [
            "id" : docId,
            "userId" : userId,
            "image" : image,
            "tittle": recipeName,
            "ingrediants":ingrediants,
            "description":description,
            "category" : category
        ]
        print(recipe)

        
         db.collection("recipe").document(docId).setData(recipe,merge: false)
         //try await getRecipe()
    }
    
    
    func getRecipe()async throws{
        
        let snapshot = try await db.collection("recipe").getDocuments()
    
        for recipe in snapshot.documents{
            
            let recipess =  recipe.data()
            let im = recipess["image"] as! String
            let manges = try await imagePicker.getImage(path: im)
            
            
            let a = Recipe(id: recipess["id"] as! String, userId: recipess["userId"] as! String, image:manges, ingrediants: recipess["ingrediants"] as! String, description: recipess["description"] as! String, name: recipess["tittle"] as! String, category: recipess["category"] as! String)
            if recipeList.contains(a){
                print("ksfkjwakrjfkaj")
            }
            else{
                recipeList.append(a)
            }
        }
    
    }
    
    func getFavRecipe(recipeId:String) async throws{
        
        let doc = try await db.collection("recipe").document(recipeId).getDocument()
        let favRecipes = doc.data()
        let im = favRecipes?["image"]
        let manges = try await imagePicker.getImage(path: im as! String)

        let favRec = Recipe(id: favRecipes?["id"] as! String, userId: favRecipes?["userId"] as! String, image:manges, ingrediants: favRecipes?["ingrediants"] as! String, description: favRecipes?["description"] as! String, name: favRecipes?["tittle"] as! String, category: favRecipes?["category"] as! String)
        
        favRecipieList.append(favRec)
    }
}
