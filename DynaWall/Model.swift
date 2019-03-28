//
//  Model.swift
//  DynaWall
//
//  Created by Shivesh M M on 28/03/19.
//  Copyright © 2019 hyperionStudios. All rights reserved.
//

import Cocoa

class tableCellDataModel {
    var rowidx: Int
    var fileName: URL
    var isForDark: Bool
    var isForLight: Bool
    init?(row: Int, fileName: URL, isForDark: Bool, isForLight: Bool) {
        if isForLight == true && isForDark == true {
            return nil
        }
        self.rowidx = row
        self.fileName = fileName
        self.isForDark = isForDark
        self.isForLight = isForLight
    }
    func getUrl() -> URL {
        return fileName
    }
}

