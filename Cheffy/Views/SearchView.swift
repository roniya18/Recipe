//
//  SearchView.swift
//  Cheffy
//
//  Created by alkesh s on 10/05/23.
//

import SwiftUI



struct SearchView: View {
    
    @ObservedObject var viewModel = RecipeViewModel.shared
    @State var recipe = RecipeViewModel.shared.recipeList
    @State var searchText = ""
    
    var filteredRecipes: [Recipe]? {
            if searchText.isEmpty {
                return nil
            } else {
                return recipe.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            }
        }
    
    var body: some View {
        NavigationStack{
            VStack{
                if filteredRecipes == nil {
                    
                }else{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 170))], spacing: 20){
                        ForEach(filteredRecipes!){ item in
                            HomeCard(image: item.image, name: item.name)
                        }
                    }
                    Spacer()
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Search")
           
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
            SearchView()
    }
}
