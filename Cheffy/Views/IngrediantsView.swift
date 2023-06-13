//
//  IngrediantsView.swift
//  Cheffy
//
//  Created by alkesh s on 09/05/23.
//

import SwiftUI
import OpenAISwift

class ApiModel: ObservableObject{
    init(){}
    
    private var client : OpenAISwift?
    
    func setup(){
        client = OpenAISwift(authToken: key)
    }
    
    func send(text:String,completion: @escaping (String) -> Void){
        client?.sendCompletion(with:"create a recipe using only \(text)" ,maxTokens: 500, completionHandler: { result in
            switch result{
                
            case .success(let model):
                
                let output = model.choices?.first?.text ?? ""
                print(model)
                completion (output)
            case .failure:
                print("no data")
            }
        })
    }
    
}


struct IngrediantsView: View {
    @ObservedObject var viewModel = ApiModel()
    @State var text = ""
    @State var recipe = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    TextField("Enter the ingredients", text: $text)
                        .padding()
                        .frame(width: 300,height: 40)
                        .background(Color(.tertiarySystemFill))
                        .cornerRadius(5)
                        .padding(.vertical)
                    Button("Generate Recipe", action: {
                        send()
                    })
                    .buttonStyle(.bordered)
                    Spacer()
                    Text(recipe)
                    
                }
                .onAppear(){
                    viewModel.setup()
            }
                .padding(20)
            }
            .navigationTitle("Get Recipe")

        }

    }
    func send(){
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                recipe = response
            }
        }
    }
}

struct IngrediantsView_Previews: PreviewProvider {
    static var previews: some View {
        IngrediantsView()
    }
}
