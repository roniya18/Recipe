//
//  CategoryItemView.swift
//  Cheffy
//
//  Created by alkesh s on 10/05/23.
//

import SwiftUI

struct CategoryItemView: View {
    
    @State var feachedCategory :String
    @ObservedObject var viewModel = RecipeViewModel.shared
    @State var recipe = RecipeViewModel.shared.recipeList
    
    var filteredRecipes: [Recipe]? {
       
            return recipe.filter { $0.category.lowercased().contains(feachedCategory.lowercased()) }
        }

    
    var body: some View {
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
            .navigationTitle(feachedCategory)
    }
}

struct CategoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItemView(feachedCategory: "")
    }
}
