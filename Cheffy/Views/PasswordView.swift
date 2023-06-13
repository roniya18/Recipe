//
//  PasswordView.swift
//  Cheffy
//
//  Created by alkesh s on 15/05/23.
//

import SwiftUI

class PasswordVM: ObservableObject{
    @Published var newPassword      = ""
    @Published var confirmPassword  = ""
    
    func updatePassword()async throws{
            try await AuthenticationModel.shared.updatePassword(password: newPassword)
    }
}

struct PasswordView: View {
    //@State var currentPassword  = ""
    @StateObject var vm = PasswordVM()
   
    
    var body: some View {
        
        
        VStack{
//            TextField("Current Password", text: $currentPassword)
//                .padding()
//                .frame(width: 300,height: 40)
//                .background(Color(.tertiarySystemFill))
//                .cornerRadius(5)
//                .padding(.vertical)
            TextField("New Password", text: $vm.newPassword)
                .padding()
                .frame(width: 300,height: 40)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(5)
                .padding(.vertical)
            TextField("Confirm Password", text: $vm.confirmPassword)
                .padding()
                .frame(width: 300,height: 40)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(5)
                .padding(.vertical)
            Spacer()
            Button(action: {
                if vm.newPassword == vm.confirmPassword{
                    Task{
                        do{
                            try await vm.updatePassword()
                        }
                        catch{
                            print(error.localizedDescription)
                        }
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
            Spacer()
        }
        .navigationTitle("Change Password")
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView()
    }
}
