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
    
    func removeImage(name: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                  name != .empty else {
            return
        }
        
        let fileURL = documentDirectory.appendingPathComponent(name)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
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
    
    func saveCustomImage(customImage: CustomPic) {
        var array = getCustomImages()
        array.insert(customImage, at: .zero)
        
        let imagesinfo = array.map { $0.info }
        
        UserDefaults.standard.set(encodable: imagesinfo, forKey: .keyCustomImagesList)
    }
    
    func getCustomImages() -> [CustomPic] {
        guard let picsInfo = UserDefaults.standard.get([PicInfo].self, forKey: .keyCustomImagesList) else { return [] }
        
        var array = [CustomPic]()
        
        for item in picsInfo {
            let image = getImage(fileName: item.imageFileName) ?? UIImage()
            array.append(CustomPic(info: item, image: image))
        }
        
        return array
    }
    
    func saveCustomImages(customImages: [CustomPic]) {
        let array = customImages.map { $0.info }
        UserDefaults.standard.set(encodable: array, forKey: .keyCustomImagesList)
    }
    
    private func getImage(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileUrl.path)
    }
    
    func savePassword(password: String?) {
        UserDefaults.standard.set(password, forKey: .keyPassword)
    }
    
    func getPassword() -> String? {
        return UserDefaults.standard.string(forKey: .keyPassword)
    }
}
