//
//  AutomaticContainerBuilder.swift
//  DynaWall
//
//  Created by Shivesh M M on 26/6/19.
//  Based on Wallpapper
//  Copyright © 2019 hyperionStudios. All rights reserved.
//

import Foundation
import AppKit
import AVFoundation

class AutomaticContainerBuilder {
    
    var pathList: [tableCellDataModel]
    let baseURL: URL    // Destination Folder : ~/Downloads
    let outputFileName: String  // Output File name : output.heic
    let options = [kCGImageDestinationLossyCompressionQuality: 1.0]
    let loadingSpinner: NSProgressIndicator
    let label: NSTextField
    
    init(pathList: [tableCellDataModel], baseURL: URL, outputFileName: String, loadingSpinner: NSProgressIndicator, withInfoLabel label: NSTextField) {
        self.pathList = pathList
        self.baseURL = baseURL
        self.outputFileName = outputFileName
        self.loadingSpinner = loadingSpinner
        self.label = label
        DispatchQueue.main.async {
            self.loadingSpinner.isIndeterminate = false
            self.loadingSpinner.doubleValue = 0.0
        }
    }
    
    func run() throws {
        if #available(OSX 10.13, *) {
            let destinationData = NSMutableData()
            if let destination = CGImageDestinationCreateWithData(destinationData, AVFileType.heic as CFString, self.pathList.count, nil) {
                
                self.pathList.sort { (left, right) -> Bool in
                    return left.isPrimary == true
                }
                
                for (index, pictureInfo) in self.pathList.enumerated() {
                    let fileURL = pictureInfo.fileName
                    
                    guard let orginalImage = NSImage(contentsOf: fileURL) else {
                        return
                    }
                    
                    
                    if let cgImage = orginalImage.CGImage {
                        
                        if index == 0 {
                            let imageMetadata = CGImageMetadataCreateMutable()
                            
                            guard CGImageMetadataRegisterNamespaceForPrefix(imageMetadata, "http://ns.apple.com/namespace/1.0/" as CFString, "apple_desktop" as CFString, nil) else {
                                return
                            }
                            
                            let base64PropertyList = appleKnowsBest()   // Metadata from the Default Mojave wallpaper
                            
                            let imageMetadataTag = CGImageMetadataTagCreate("http://ns.apple.com/namespace/1.0/" as CFString, "apple_desktop" as CFString, "solar" as CFString, CGImageMetadataType.string, base64PropertyList as CFTypeRef)
                            
                            guard CGImageMetadataSetTagWithPath(imageMetadata, nil, "apple_desktop:solar" as CFString, imageMetadataTag!) else {
                                return
                            }
                            
                            CGImageDestinationAddImageAndMetadata(destination, cgImage, imageMetadata, self.options as CFDictionary)
                            DispatchQueue.main.async {
                                self.loadingSpinner.doubleValue = Double(index+1)*100.0/16
                            }
                        } else {
                            CGImageDestinationAddImage(destination, cgImage, self.options as CFDictionary)
                            DispatchQueue.main.async {
                                self.loadingSpinner.doubleValue = Double(index+1)*100.0/16
                                if index == 15 {
                                    self.loadingSpinner.isIndeterminate = true
                                    self.loadingSpinner.startAnimation(self)
                                    self.label.stringValue = "Saving HEIC Image..."
                                }
                            }
                        }
                    }
                }
                guard CGImageDestinationFinalize(destination) else {
                    return
                }
                let outputURL =  baseURL.appendingPathComponent(self.outputFileName)
                let imageData = destinationData as Data
                try imageData.write(to: outputURL)
                DispatchQueue.main.async {
                    self.loadingSpinner.stopAnimation(self)
                }
            }
        } else {
            return
        }
    }
}

