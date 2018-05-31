//
//  Constants.swift
//  Quick & Easy Photo ID
//
//  Created by Nirav Gondaliya on 09/05/18.
//  Copyright © 2018 Nirav Gondaliya. All rights reserved.
//

import Foundation

struct Constants {
    
    static let countryAmerica = "America"
    static let countryBangladesh = "Bangladesh"
    static let countryCanada = "Canada"
    static let countryChina = "China"
    static let countryIndia = "India"
    static let countryPakistan = "Pakistan"
    static let countrySchengen = "Schengen"
    
    
    static let americanList = ["Visa"]
    static let americanSizeList = ["35 * 35 mm"]
    static let americanAspectRatioList = ["35:35"]
    
    static let bangladeshList = ["Passport"]
    static let bangladeshSizeList = ["45 * 55 mm"]
    static let bangladeshAspectRatioList = ["45:55"]
    
    static let canadaList = ["Passport", "Visa"]
    static let canadaSizeList = ["50 * 70 mm", "35 * 45 mm"]
    static let canadaAspectRatioList = ["50:70", "35:45"]
    
    static let chinaList = ["Visa"]
    static let chinaSizeList = ["33 * 48 mm"]
    static let chinaAspectRatioList = ["33:48"]
    
    static let indianList = ["Passport", "Visa Online", "Pan Card", "Birth Registration"]
    static let indianSizeList = ["51 * 51 mm", "350 * 350 pixel", "25 * 35 mm", "100 * 120 pixel"]
    static let indianAspectRatioList = ["51:51", "350:350", "25:35", "100:120"]
    
    static let pakistanList = ["Nadra or NICOP"]
    static let pakistanSizeList = ["35 * 45 mm"]
    static let pakistanAspectRatioList = ["35:45"]
    
    static let schengenList = ["Visa"]
    static let schengenSizeList = ["35 * 45 mm"]
    static let schengenAspectRatioList = ["35:45"]
}

enum counrtyType {
    case America
    case Bangladesh
    case Canada
    case China
    case India
    case Pakistan
    case Schengen
}

let kImageSave = "Image saved successfully."
let kAddImage = "You can save only 5 image in free version."
