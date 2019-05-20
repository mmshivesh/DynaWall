//
//  Model.swift
//  DynaWall
//
//  Created by Shivesh M M on 28/03/19.
//  Copyright © 2019 hyperionStudios. All rights reserved.
//

import Cocoa

class tableCellDataModel: NSObject {
    @objc dynamic var rowidx: Int
    @objc dynamic var fileName: URL
//    var fileNameString: String
    @objc dynamic var displayName: String
    @objc dynamic var isPrimary: Bool
    @objc dynamic var isForDark: Bool
    @objc dynamic var isForLight: Bool
    @objc dynamic var altitude: Double
    @objc dynamic var azimuth: Double
    
    init(row: Int, fileName: URL, isPrimary: Bool, isForDark: Bool, isForLight: Bool, altitude: Double, azimuth: Double) {
        self.rowidx = row
        self.fileName = fileName
        self.displayName = fileName.lastPathComponent
        self.isPrimary = isPrimary
        self.isForDark = isForDark
        self.isForLight = isForLight
        self.altitude = altitude
        self.azimuth = azimuth
    }
    func setDark() {
        isForDark = true
        isForLight = false
    }
    func setLight() {
        isForDark = false
        isForLight = true
    }
    func getUrl() -> URL {
        return fileName
    }
}

