//
//  Recipe.swift
//  Cheffy
//
//  Created by alkesh s on 20/05/23.
//

import Foundation
import UIKit


struct Recipe : Identifiable,Hashable{
    
    var id : String
    var userId : String
    var image : UIImage
    var ingrediants : String
    var description : String
    var name : String
    var category :String
}

struct Comment :Hashable{
    var user : String
    var comment : String
}

struct Users{
    var image:UIImage
    var name :String
}
