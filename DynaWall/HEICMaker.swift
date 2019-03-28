//
//  HEICMaker.swift
//  DynaWall
//
//  Created by Shivesh M M on 26/03/19.
//  Copyright © 2019 hyperionStudios. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation

class HEICMaker {
    var imageURLS:[URL] = []
    func buildContainer() {
        
        let dummyData = NSMutableData()
        let outputImage = CGImageDestinationCreateWithData(dummyData, AVFileType.heic as CFString,self.imageURLS.count, nil)
        for (id,url) in imageURLS.enumerated()
        {
            let readImage = NSImage.init(contentsOf: url)
            // For the first image, we need to add the created metadata
                if id==0 {
                    let metadata = CGImageMetadataCreateMutable()
                    CGImageMetadataRegisterNamespaceForPrefix(metadata, "http://ns.apple.com/namespace/1.0/" as CFString, "apple_desktop" as CFString, nil)
                        CGImageDestinationAddImageAndMetadata(outputImage!,readImage!.CGImage!, metadata, nil)
                    
                }
                else {
                }
        }
    }
    func plistCreate() {

    }
}
