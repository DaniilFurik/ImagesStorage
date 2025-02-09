//
//  ImageInfo.swift
//  ImagesStorage
//
//  Created by Даниил on 10.02.25.
//

final class PicInfo: Codable {
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
