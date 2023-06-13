//
//  RecipeView.swift
//  Cheffy
//
//  Created by alkesh s on 10/05/23.
//

import SwiftUI

struct RecipeView: View {
    
    @ObservedObject var vm = ViewModel()
    @State var recipie : Recipe
    @State private var isCommentViewPresented = false
    @ObservedObject var viewModel = CommentManager.shared
    @State var imageName = "heart"
    @State var imageColor = Color.black


    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                VStack{
                    Image(uiImage: recipie.image)
                        .resizable()
                        .frame(height: 300)
                        .cornerRadius(10)
                    HStack{
                        Spacer()
                        Image(systemName: imageName)
                            .resizable()
                            .frame(width: 32,height: 30)
                            .foregroundColor(imageColor)
                            .onTapGesture {
                                
                                vm.addFavRecipe(productId: recipie.id)
                                if imageName == "heart" {
                                    imageName = "heart.fill"
                                    imageColor = Color.red
                                }
                                else{
                                    imageName = "heart"
                                    imageColor = Color.black
                                }
                            }
                        Spacer()
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .frame(width: 25,height: 30)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "bubble.left")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .foregroundColor(.black)
                            .onTapGesture {
                                viewModel.commentList = []
                                Task{
                                    try await viewModel.getComment(recipeId: recipie.id)
                                }
                                isCommentViewPresented.toggle()
                            }
                            .sheet(isPresented: $isCommentViewPresented, content: {
                                CommentView(recipeId: recipie.id)
                            })
                        Spacer()
                    }
                }
                .padding(.vertical,20)
                VStack(alignment: .leading){
                    Text(recipie.name)
                        .font(.title)
                        .fontWeight(.medium)
                        .padding(.bottom,10)
                    Text("Ingrediants")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text(recipie.ingrediants)
                    Text("Description")
                        .padding(.top,10)
                        .font(.title2)
                        .fontWeight(.medium)
                    Text(recipie.description)
                }
                .padding(20)
            }
            
        }
        .ignoresSafeArea()
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipie: Recipe(id: "", userId: "", image: UIImage(), ingrediants: "", description: "", name: "", category: ""))
    }
}
