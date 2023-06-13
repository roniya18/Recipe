//
//  StorageManager.swift
//  Cheffy
//
//  Created by alkesh s on 19/05/23.
//

import Foundation
import SwiftUI
import FirebaseStorage

class StorageManager {
    
    static let shared = StorageManager()
    private init() { }
    
    private let storage = Storage.storage().reference()
    
    
    func saveImage(data:Data) async throws -> String{
        
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        
        let path = "\(UUID().uuidString).png"
        let returnedMetaData = try await storage.child(path).putDataAsync(data,metadata:meta)
        
        guard let returnedPath = returnedMetaData.path /*let returnedName = returnedMetaData.name*/ else {
            throw URLError(.badServerResponse)
        }
        return (returnedPath)
    }
    
    func getImage(path:String) async throws -> UIImage?{
            let data = try await storage.child(path).data(maxSize: 5 * 1024 * 1024)
            let image = UIImage(data: data)
            return image
    }
}
