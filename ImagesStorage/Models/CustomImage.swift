//
//  CustomImage.swift
//  ImagesStorage
//
//  Created by Даниил on 7.01.25.
//

final class CustomImage {
    let note: String
    let isFavorite: Bool
    let imageFileName: String
    let date: Int
    
    init(note: String, isFavorite: Bool, imageFileName: String, date: Int) {
        self.note = note
        self.isFavorite = isFavorite
        self.imageFileName = imageFileName
        self.date = date
    }
}
