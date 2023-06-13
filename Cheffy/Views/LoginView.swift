//
//  LoginView.swift
//  Cheffy
//
//  Created by alkesh s on 09/05/23.
//

import SwiftUI


class signInViewModel: ObservableObject{
    
    @Published var email = ""
    @Published var password = ""

    
    func signIn() async throws {
        let authDataResult = try await AuthenticationModel.shared.signInUser(email: email, password: password)
    }
    
}

struct LoginView: View {
    
    @AppStorage("LOGIN_STATUS") var LOGIN_STATUS = false
    @State var isAlertOn : Bool = false
    @State var errorMessage = ""
    @StateObject var viewModel = signInViewModel()
    @State private var isRegisterViewPresented = false
    
    
    var body: some View {
        ZStack{
            Image("Pasta")
                .resizable()
                .frame(width: 600.0, height: 940.0)
                .offset(y:-20)
            VStack{
                Spacer()
                Text("Login")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                Spacer()
                Group{
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
                        do{
                            
                            try await viewModel.signIn()
                            LOGIN_STATUS = true
                            await UserManager.shared.getUserData()

                            
                        }
                        catch{
                            isAlertOn = true
                            errorMessage = error.localizedDescription
                        }
                    }
                }, label: {
                    Text("Login")
                        .foregroundColor(.white)
                        .bold()
                        .font(.system(size: 25))
                        .frame(width: 300,height: 50)
                        .background(Color.teal)
                        .cornerRadius(5)
                })
                .alert(isPresented: $isAlertOn) {
                        Alert(title: Text("Alert"), message: Text("Invalid Email Or Password"), dismissButton: .default(Text("OK")))
                    }
                Spacer()
                Text("Not Registered yet? Register Now")
                    .bold()
                    .offset(y:20)
                    .onTapGesture {
                        isRegisterViewPresented.toggle()
                    }
                    .sheet(isPresented: $isRegisterViewPresented, content: {
                        RegisterView()
                    })
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
