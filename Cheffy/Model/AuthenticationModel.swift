//
//  AuthenticationModel.swift
//  Cheffy
//
//  Created by alkesh s on 12/05/23.
//

import Foundation
import FirebaseAuth

struct AuthdataResultModel{
    
    let uid : String
    let email : String?
    
    
    init(user:User) {
        self.uid = user.uid
        self.email = user.email
    }
}

class AuthenticationModel:ObservableObject {
    
    static let shared = AuthenticationModel()
    private init() { }
    
    func createUser(email: String, password: String) async throws -> AuthdataResultModel{
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthdataResultModel(user: authDataResult.user)
    }
    
    func signInUser(email: String, password: String) async throws -> AuthdataResultModel{
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthdataResultModel(user: authDataResult.user)
    }
    
    func getUser() throws -> AuthdataResultModel{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badURL)
        }
        return AuthdataResultModel(user: user)
    }
    
    func getUserId() -> String? {
        
            do{
                let authDataModel = try getUser()
                return authDataModel.uid
            }
            catch{
                print(error)
                return nil
            }
    }
    
    func updatePassword(password:String) async throws{
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updatePassword(to:password )
    }
    
    func signOut() throws {
       try Auth.auth().signOut()
    }
    
}
  
