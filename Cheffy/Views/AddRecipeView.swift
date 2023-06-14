//
//  AddRecipeView.swift
//  Cheffy
//
//  Created by alkesh s on 09/05/23.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseFirestoreSwift




struct AddRecipeView: View {
    
    @State var categories = ["Breakfast","Lunch","Drinks","Pastas","Salad","Deserts","Soup"]
    @StateObject var viewModel = RecipeViewModel.shared
    @StateObject var imagePicker = ImagePicker()
    @State var isAlertOn : Bool = false
    @State var issAlertOn : Bool = false

    
   
    var body: some View {
      
        VStack {
            Text("New Recipe")
                .bold()
                .font(.system(size: 30))
                .padding(.vertical,30)
         
            
            if let image = imagePicker.image {
                
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300.0, height: 200.0)

                        }
                else {
                            ZStack{
                                Rectangle()
                                    .frame(width: 300.0, height: 200.0)
                                    .foregroundColor(Color(.tertiarySystemFill))
                                    .cornerRadius(10)
                                VStack {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                    .frame(width: 30,height: 30)
                                    
                                }
                            }
                        }
            
            PhotosPicker(selection: $imagePicker.imageSelection) {
                Text("Tap to add photo")
                    .foregroundColor(Color.secondary)
                        }
          
            Group{
                FieldView(placeHolder: "Name", variable: $viewModel.recipeName)
                   
                Menu{
                    Picker(selection: $viewModel.category,
                           label:Text("Categories"),
                           content: {
                        ForEach(categories, id: \.self) { options in
                            Text(options).tag(options)
                        }
                    })
                }label: {
                    Text(viewModel.category)
                        .foregroundColor(Color.secondary)
                        .multilineTextAlignment(.leading)
                        .frame(width: 300,height: 40)
                        .background(Color(.tertiarySystemFill))
                        .cornerRadius(5)
                        .padding(.vertical)
                }
                
                FieldView(placeHolder: "Description", variable: $viewModel.description)
                FieldView(placeHolder: "Ingrediants", variable: $viewModel.ingrediants)
                    
            }
            
            Button(action: {
                if viewModel.recipeName == nil || viewModel.ingrediants == nil || viewModel.description == nil || viewModel.category == nil || imagePicker.image == nil {
                    
                    isAlertOn = true
                    
                }else {
                    let data = imagePicker.data
                    Task{
                        await imagePicker.saveImage(data: data!)
                        
                        try? await viewModel.addRecipe()
                        await viewModel.recipeName = ""
                        await viewModel.ingrediants = ""
                        await viewModel.description = ""
                        await viewModel.category = ""
                        await imagePicker.image = nil
                        await issAlertOn = true
                        await viewModel.recipeList = []
                        try await viewModel.getRecipe()
                    }
                }
            }, label: {
                Text("Add")
                    .foregroundColor(.white)
                    .bold()
                    .font(.system(size: 25))
                    .frame(width: 300,height: 50)
                    .background(Color.teal)
                    .cornerRadius(5)
            })
            .padding(.vertical,20)
            .alert(isPresented: $issAlertOn) {
                Alert(title: Text("Alert"), message: Text("New recipe added"), dismissButton: .default(Text("OK")))
            }
            Spacer()
            .alert(isPresented: $isAlertOn) {
                Alert(title: Text("Alert"), message: Text("All fields must be filled"), dismissButton: .default(Text("OK")))
            }
            
        }
        
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}

struct FieldView: View {
    var placeHolder : String
    @Binding var variable : String
    var body: some View {
        TextField(placeHolder, text: $variable, axis: .vertical)
            .lineLimit(4)
            .padding(.leading,20)
            .frame(width: 300,height: 40)
            .background(Color(.tertiarySystemFill))
            .cornerRadius(5)
            .padding(.vertical)
    }
}
