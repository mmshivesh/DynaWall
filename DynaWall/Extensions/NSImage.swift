//
//  NSImage.swift
//  DynaWall
//
//  Created by Shivesh M M on 26/03/19.
//  Copyright © 2019 hyperionStudios. All rights reserved.
//

import Foundation
import AppKit

extension NSImage {
    // NSImage to CGImage converter extension
    var CGImage : CGImage? {
        let sourceCreate = CGImageSourceCreateWithData(self.tiffRepresentation! as CFData, nil)
        return CGImageSourceCreateImageAtIndex(sourceCreate!, 0, nil)
    }
}
