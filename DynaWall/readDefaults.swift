//
//  readDefaults.swift
//  DynaWall
//
//  Created by Shivesh M M on 26/6/19.
//  Copyright © 2019 hyperionStudios. All rights reserved.
//

import Foundation
import ImageIO

func appleKnowsBest() -> String {
    let url = URL(fileURLWithPath: "/Library/Desktop Pictures/Mojave.heic")
    let imageData:Data = try! Data(contentsOf: url)
    var result:String = ""
    if let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
        let imageProperties = CGImageSourceCopyMetadataAtIndex(imageSource, 0, nil) {
        CGImageMetadataEnumerateTagsUsingBlock(imageProperties, nil, nil, { (key, tag) -> Bool in
            let tagString:NSString = CGImageMetadataTagCopyName(tag) as! NSString
            if tagString == "solar" {
                result = (CGImageMetadataTagCopyValue(tag) as! NSString) as String
                return false
            }
            return true
        })
    }
    return result
}
