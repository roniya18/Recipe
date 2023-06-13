//
//  ProfileView.swift
//  Cheffy
//
//  Created by alkesh s on 15/05/23.
//

import SwiftUI

class signOutModel: ObservableObject{
    
    
    func signOut() throws {
        try AuthenticationModel.shared.signOut()
    }
}

struct ProfileView: View {
    
    @AppStorage("LOGIN_STATUS") var LOGIN_STATUS = false
    @StateObject var viewModel = signOutModel()
    @ObservedObject var imageVM = ImagePicker()
    @ObservedObject var vm = UserManager.shared
    @State var isLoggedOut = false
    
    var body: some View {
        NavigationStack {
            VStack{
                    Spacer()
                    Image(uiImage: vm.users.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120,height: 120)
                    Text(vm.users.name)
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                    Spacer()
                   
                    NavigationLink(destination: MyRecipeView(), label: {
                        SettingButtonView(image: "doc.text.fill", text: "My Recipes")
                    })
                    NavigationLink(destination: PasswordView(), label: {
                        SettingButtonView(image: "lock.fill", text: "Change Password")
                    })
                    SettingButtonView(image: "rectangle.portrait.and.arrow.forward.fill", text: "Logout")
                        .onTapGesture {
                            Task{
                                do{
                                    try viewModel.signOut()
                                    LOGIN_STATUS = false
                                }
                                catch{

                                }
                            }
                            
                        }
                    Spacer()
                    
            }
        }
        }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct SettingButtonView: View {
    let image : String
    let text : String
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 350,height: 55)
                .foregroundColor(Color(.tertiarySystemFill))
                .cornerRadius(55)
            HStack{
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30,height: 30)
                Text(text)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.leading,20)
                Spacer()
            }
            .padding()
        }
        .frame(width: 350,height: 55)
        .padding()
    }
}
