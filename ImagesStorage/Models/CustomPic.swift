//
//  CustomImage.swift
//  ImagesStorage
//
//  Created by Даниил on 7.01.25.
//

import UIKit

final class CustomPic {
    var info: PicInfo
    var image: UIImage
    
    init(info: PicInfo, image: UIImage) {
        self.image = image
        self.info = info
    }
    
    init() {
        self.image = UIImage()
        self.info = PicInfo()
    }
}
