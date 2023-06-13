//
//  HomeCard.swift
//  Cheffy
//
//  Created by alkesh s on 09/05/23.
//

import SwiftUI

struct HomeCard: View {
    
    let image : UIImage
    let name : String
    
    var body: some View {
       
        
            ZStack{
                
                Image(uiImage:image)
                            .resizable()
                            .frame(width: 155,height: 155)
                            .cornerRadius(10)
            
            VStack{
                
                
                Text(name)
                    .frame(width: 150.0)
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            }
        }
    }
        
}
    

struct HomeCard_Previews: PreviewProvider {
    static var previews: some View {
        HomeCard(image: UIImage() , name: "").previewLayout(.sizeThatFits)
    }
}
