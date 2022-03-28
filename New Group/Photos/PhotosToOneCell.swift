//
//  PhotosToOneCell.swift
//  Navigation
//
//  Created by Админ on 06.04.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

struct PhotoToOneCell {
    var imageName: String?
}

struct PhotoSet {
    static var photoSet: [PhotoToOneCell] = [
        PhotoToOneCell(imageName: "bruce_lee_2"),
        PhotoToOneCell(imageName: "d_chan"),
        PhotoToOneCell(imageName: "ip_man_2"),
        PhotoToOneCell(imageName: "panda")
    ]
}

