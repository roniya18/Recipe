//
//  ImagePicker.swift
//  Cheffy
//
//  Created by alkesh s on 19/05/23.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

@MainActor
class ImagePicker : ObservableObject{
    
    @Published var image : Image?
    @Published var data : Data?
    @Published var imageSelection : PhotosPickerItem? {
        didSet{
            if let imageSelection {
                Task{
                    try await loadTransferable(from:imageSelection)
                }
            }
        }
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do{
            if let data = try await imageSelection?.loadTransferable(type: Data.self){
                self.data = data
                //               saveImage(data: data)
                if let uiImage = UIImage(data: data){
                    self.image = Image(uiImage: uiImage)
                }
            }
        }
        catch {
            print(error.localizedDescription)
            image = nil
        }
    }
    
    func saveImage(data:Data) async  {
        do{
            let path = try await StorageManager.shared.saveImage(data: data)
            print(path)
            
            RecipeViewModel.shared.image = path
        }
        catch{
            print(error)
        }
    }
    
    func saveProfileImage(data:Data) async {
        do{
            let path = try await StorageManager.shared.saveImage(data: data)
            print(path)
            
            UserManager.shared.image = path
        }
        catch{
            print(error)
        }
    }
    
    
    func getImage(path:String) async throws -> UIImage{
        do{
            let images = try await StorageManager.shared.getImage(path:path)
            print("sdksajnncakjfjnnv")
            return images!
           
        }
        catch{
            print(error.localizedDescription)
            throw error
        }
    }
}
