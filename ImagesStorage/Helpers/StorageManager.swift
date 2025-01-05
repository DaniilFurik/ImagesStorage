//
//  StorageManager.swift
//  Racing2D
//
//  Created by Даниил on 13.12.24.
//

import UIKit

final class StorageManager {
    // MARK: - Properties
    
    static let shared = StorageManager()
    
    private init() { }
}

extension StorageManager {
    // MARK: - Methods
    
    func saveImage(image: UIImage) -> String? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let data = image.jpegData(compressionQuality: 1) else {
            return nil
        }
        
        let fileName = UUID().uuidString
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getImage(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileUrl.path)
    }
}
