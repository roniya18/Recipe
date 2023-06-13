//
//  CommentManager.swift
//  Cheffy
//
//  Created by alkesh s on 23/05/23.
//

import Foundation
import Firebase

@MainActor
class CommentManager : ObservableObject{
    
    static let shared = CommentManager()
    private init() { }

    @Published var comment = ""
    @Published var commentList : [Comment] = []
    
    
    
    func addComment(recipeId:String,userName:String)async throws{
    
        let recipe : [String:Any] = [
            "userName" : userName,
            "comment" : comment
        ]
        
        let db = Firestore.firestore()
       try await db.collection("recipe").document(recipeId).collection("comments").document().setData(recipe, merge: false)
        try await getComment(recipeId: recipeId)
        
    }
    
    func getComment(recipeId:String)async throws {
        var comments : [Comment] = []
        let db = Firestore.firestore()
        
        
        let doc = db.collection("recipe").document(recipeId).collection("comments").addSnapshotListener({ querrySnapshot, error in
            if let error = error{
               print(error)
                return
            }
            querrySnapshot?.documents.forEach({ queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let comment = Comment(user: data["userName"] as! String, comment: data["comment"] as! String)
                if !comments.contains(comment){
                    comments.append(comment)
                }
            })
            self.commentList = comments
        })
        
        
//            for data in doc.documents{
//                let com = data.data()
//                let comment = Comment(user: com["userName"] as! String, comment: com["comment"] as! String)
//                if !comments.contains(comment){
//                    comments.append(comment)
//                }
//            }
//        commentList = comments
    
    }
}
