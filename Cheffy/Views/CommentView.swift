//
//  CommentView.swift
//  Cheffy
//
//  Created by alkesh s on 23/05/23.
//

import SwiftUI


struct CommentView: View {
    
    
    @State var recipeId : String
    @ObservedObject var vm = AuthenticationModel.shared
    @ObservedObject var viewModel = CommentManager.shared
    @Environment(\.presentationMode) private var presentationMode

    
    var body: some View {
        
        VStack{
            List{
                ForEach(viewModel.commentList,id: \.self){item in
                    
                    VStack(alignment: .leading){
                        Text(item.user)
                            .fontWeight(.bold)
                        Text(item.comment)
                    }
                }
            }
            .listStyle(.plain)
            HStack{
                TextField("Comment", text: $viewModel.comment)
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 25))
                    .onTapGesture {
                        Task{
                            let authDataResult = try vm.getUser()
                            try await viewModel.addComment(recipeId: recipeId, userName: authDataResult.email!)
                            await viewModel.comment = ""
                        }
                    
                    }
            }
        }

        .padding()
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(recipeId: "")
    }
}
