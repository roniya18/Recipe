//
//  FavouritesView.swift
//  Cheffy
//
//  Created by alkesh s on 09/05/23.
//

import SwiftUI

struct FavouritesView: View {
    
    @ObservedObject var viewModel = UserManager.shared
    @ObservedObject var vm = RecipeViewModel.shared
    
    var body: some View {
       // NavigationStack{
            VStack{
                Text("Favourites")
                    .bold()
                    .font(.system(size: 30))
                    .padding(.bottom,50)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 170))], spacing: 20){
                    ForEach(vm.favRecipieList){ item in
//                        NavigationLink(value: item,
//                                       label: {
                            HomeCard(image: item.image, name: item.name)
//                        }
//                                       )
//                        .navigationDestination(for: Recipe.self) { recipe in
//                            RecipeView(recipie: recipe)
//                    }
                  
                }
                
                }
                Spacer()
            }
       // }
        .onAppear(){
            Task{
                try await viewModel.getFavRecipies()
            }
        }
        .onDisappear(){
            vm.favRecipieList = []
        }
    }
        
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
