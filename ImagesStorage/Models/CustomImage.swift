//
//  CustomImage.swift
//  ImagesStorage
//
//  Created by Даниил on 7.01.25.
//

final class CustomImage: Codable {
    var note: String
    var isFavorite: Bool
    var imageFileName: String
    var date: Double
    
    init () {
        note = .empty
        isFavorite = false
        imageFileName = .empty
        date = .zero
    }
}
