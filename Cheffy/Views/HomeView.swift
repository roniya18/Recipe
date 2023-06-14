//
//  HomeView.swift
//  Cheffy
//
//  Created by alkesh s on 09/05/23.
//

import SwiftUI

class ViewModel:ObservableObject{
    
    func addFavRecipe(productId:String){
        Task{
            let authDataResult = try AuthenticationModel.shared.getUser()
            try await UserManager.shared.addFav(userId: authDataResult.uid, recipeId: productId)
        }
    }
}

struct HomeView: View {
    
    @ObservedObject var vm = ViewModel()
    @ObservedObject var viewModel = RecipeViewModel.shared
    @State var searchText = ""
    @State var favHeart = "heart"
    @State var isAlertOn : Bool = false

    var body: some View {
        
        NavigationStack {
            ScrollView{
                VStack(alignment: .leading){
                    HStack{
                        Text("Welcome!")
                            .bold()
                            .font(.system(size: 25))
                            .padding(.vertical,20)
                        Spacer()
                        NavigationLink(destination: ProfileView(), label: {
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .frame(width: 30,height: 20)
                        })
                    }
                    Spacer()
                    Text("What do you crave today?")
                        .fontWeight(.medium)
                    Text("Whip up delicious meals with ease!")
                        .fontWeight(.light)
                        .padding(.bottom,20)
                    Spacer()
                    NavigationLink(destination: SearchView(), label: {
                        Text("Search for items")
                            .foregroundColor(Color.secondary)
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.secondary)
                    })
                    .padding()
                    .frame(width: 360,height: 50)
                    .background(Color(.tertiarySystemFill))
                    .cornerRadius(5)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 170))],spacing: 20){
                        ForEach(viewModel.recipeList){ item in
                            let i = item.image
                            let n = item.name
                            NavigationLink(
                                   value: item,
                                   label: {
                                       ZStack{
                                           HomeCard(image: i, name: n)
                                           ZStack{
                                               Rectangle()
                                                   .frame(width: 20,height: 20)
                                                   .foregroundColor(.white)
                                               Image(systemName: favHeart)
                                                   .onTapGesture {                                                       vm.addFavRecipe(productId: item.id)
                                                       isAlertOn = true
                                                   }
                                                   .alert(isPresented: $isAlertOn) {
                                                       Alert(title: Text("Alert"), message: Text("Added to favorites"), dismissButton: .default(Text("OK")))
                                                   }
                                           }
                                           .padding(.leading,120)
                                           .padding(.bottom,120)
                                       }
                                   }
                            )
                            
                        }
                    }
                    .navigationDestination(for: Recipe.self) { recipe in
                        RecipeView(recipie: recipe)
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
            }
        }
    }
       
}
   

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
       HomeView()
    }
}

