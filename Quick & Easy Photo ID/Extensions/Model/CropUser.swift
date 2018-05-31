//
//  CropUser.swift
//  Quick & Easy Photo ID
//
//  Created by Nirav Gondaliya on 09/05/18.
//  Copyright © 2018 Nirav Gondaliya. All rights reserved.
//

import Foundation
import UIKit

class CropUser {
    static let shared = CropUser()
    var image:UIImage!
    var ratio:String!
    var editedImage:UIImage!
}
