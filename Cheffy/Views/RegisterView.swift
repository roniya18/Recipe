//
//  ContentView.swift
//  Cheffy
//
//  Created by alkesh s on 09/05/23.
//

import SwiftUI
import PhotosUI

@MainActor
class RegisterViewModel: ObservableObject{
    
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    
    
    func register() async throws {
        
       let authDataResult = try await AuthenticationModel.shared.createUser(email: email, password: password)
        try await UserManager.shared.createUser(auth: authDataResult,name:fullName)

        
    }
    
}

struct RegisterView: View {
    
    @State var isAlertOn : Bool = false
    @State var errorMessage = ""
    @StateObject var viewModel = RegisterViewModel()
    @StateObject var imagePicker = ImagePicker()
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("Pasta")
                    .resizable()
                    .frame(width: 600.0, height: 940.0)
                    .offset(y:-20)
                VStack{
                    Spacer()
                    Text("Register")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                    Spacer()
                    Group{
                        if let image = imagePicker.image {
                            
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 120,height: 120)

                                    }
                        else{
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120,height: 120)
                                .foregroundColor(Color.gray)
                        }
                        PhotosPicker(selection: $imagePicker.imageSelection) {
                            Text("Add photo")
                                .foregroundColor(Color.secondary)
                                    }
                        TextField("Full Name", text: $viewModel.fullName)
                            .padding()
                            .frame(width: 300,height: 40)
                            .background(Color.white)
                            .cornerRadius(5)
                        TextField("Email", text: $viewModel.email)
                            .padding()
                            .frame(width: 300,height: 40)
                            .background(Color.white)
                            .cornerRadius(5)
                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .frame(width: 300,height: 40)
                            .background(Color.white)
                        .cornerRadius(5)
                    }
                    .padding(.vertical,10)
                    Spacer()
                    Button(action: {
                        Task{
                            if let data = imagePicker.data{
                                await imagePicker.saveProfileImage(data: data)
                            }else{
                                print("Error")
                            }
                            do{
                                try  await viewModel.register()
                                presentationMode.wrappedValue.dismiss()
                                
                            }
                            catch{
                                isAlertOn = true
                                errorMessage = error.localizedDescription
                            }
                        }
                        
                        
                    }, label: {
                        Text("Register")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 25))
                            .frame(width: 300,height: 50)
                            .background(Color.teal)
                            .cornerRadius(5)
                    })
                    .alert(isPresented: $isAlertOn) {
                            Alert(title: Text("Alert"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                        }
                    Spacer()
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
