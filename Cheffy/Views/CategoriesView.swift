//
//  CatagoriesView.swift
//  Cheffy
//
//  Created by alkesh s on 09/05/23.
//

import SwiftUI

struct CategoriesView: View {
    
    let images : [String] =  ["Breakfast","Lunch","Drinks","Pastas","Salad","Deserts","Soup"]

    var body: some View {
        NavigationStack{
                List(images,id: \.self) { item in
                    NavigationLink(value: item){
                        ExtractedView(item: item)

                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                .listStyle(PlainListStyle())
                .navigationDestination(for: String.self) { text in
                    CategoryItemView(feachedCategory: text)
            }
            .navigationTitle("Categories")
        }
        
    }
}

struct CatagoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}

struct ExtractedView: View {
    var item = ""
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color(.tertiarySystemFill))
                .frame(width: 350,height: 60)
                .cornerRadius(40)
            HStack{
                Text(item)
                Spacer()
                Image(item)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60,height: 50)
            }
            .padding()
        }
        .frame(width: 350)
    }
}
