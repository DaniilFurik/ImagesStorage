//
//  StorageManager.swift
//  Racing2D
//
//  Created by Даниил on 13.12.24.
//

import SwiftyKeychainKit
import UIKit

final class StorageManager {
    // MARK: - Properties
    
    static let shared = StorageManager()
    
    private init() { }
    
    private var keyPassword: Keychain.Key<String> { .genericPassword(key: .keyPassword) }
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
        getCustomPics { pics in
            var array = pics
            array.insert(customImage, at: .zero)
            
            let imagesinfo = array.map { $0.info }
            
            UserDefaults.standard.set(encodable: imagesinfo, forKey: .keyCustomPicsList)
        }
    }
    
    func getCustomPics(completion: @escaping ([CustomPic]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let picsInfo = UserDefaults.standard.get([PicInfo].self, forKey: .keyCustomPicsList) else {
                DispatchQueue.main.async {
                    completion([]) // Возвращаем пустой массив на главном потоке
                }
                return
            }
            
            var array = [CustomPic]()
            
            for item in picsInfo {
                let image = self.getImage(fileName: item.imageFileName) ?? UIImage()
                array.append(CustomPic(info: item, image: image))
            }
            
            DispatchQueue.main.async {
                completion(array) // Возвращаем загруженные картинки на главном потоке
            }
        }
    }
    
    private func getImage(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileUrl.path)
    }
    
    func saveCustomPics(customPics: [CustomPic]) {
        let array = customPics.map { $0.info }
        UserDefaults.standard.set(encodable: array, forKey: .keyCustomPicsList)
    }
    
    func savePassword(password: String) {
        try? Keychain().set(password, for: keyPassword)
    }
    
    func getPassword() -> String? {
        return try? Keychain().get(keyPassword)
    }
}
