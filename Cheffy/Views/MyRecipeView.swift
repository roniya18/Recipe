//
//  MyRecipeView.swift
//  Cheffy
//
//  Created by alkesh s on 15/05/23.
//

import SwiftUI


struct MyRecipeView: View {
    
    @ObservedObject var viewModel = RecipeViewModel.shared
    @State var recipe = RecipeViewModel.shared.recipeList
    @State var userID = AuthenticationModel.shared.getUserId()
    
    
    var filteredRecipes: [Recipe]? {

        return recipe.filter { $0.userId.lowercased().contains(userID!.lowercased()) }
        }

    
    var body: some View {
        
       
        
        NavigationStack {
            VStack{
                if filteredRecipes == nil {
                     
                 }else{
                     LazyVGrid(columns: [GridItem(.adaptive(minimum: 170))], spacing: 20){
                         ForEach(filteredRecipes!){ item in
                             NavigationLink(value: item,
                                            label: {
                                 HomeCard(image: item.image, name: item.name)
                             }
                             )
                             .navigationDestination(for: Recipe.self) { recipe in
                                 RecipeView(recipie: recipe)
                             }
                         }
                     }
                     Spacer()
                 }
            }
            .navigationTitle("My Recipes")
        .padding()
        }
    }
}

struct MyRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        MyRecipeView()
    }
}
