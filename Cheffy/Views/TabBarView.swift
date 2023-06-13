//
//  TabBar.swift
//  Cheffy
//
//  Created by alkesh s on 09/05/23.
//

import SwiftUI

struct TabBarView: View {
    
   // @Binding var showSignInView : Bool
    @ObservedObject var viewModel = RecipeViewModel.shared
    
    var body: some View {
        TabView{
              HomeView().tint(.black)
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            CategoriesView().tint(.black)
                .tabItem{
                    Label("Categories", systemImage: "square.grid.2x2")
                }
            FavouritesView().tint(.black)
                .tabItem{
                    Label("Favourites", systemImage: "heart")
                }
            AddRecipeView().tint(.black)
                .tabItem{
                    Label("New Recipe", systemImage: "plus")
                }
            IngrediantsView().tint(.black)
                .tabItem{
                    Label("Recipe", systemImage: "fork.knife")
                }
        }
        .navigationBarBackButtonHidden()
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
