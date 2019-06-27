//
//  AppDelegate.swift
//  DynaWall
//
//  Created by Shivesh M M on 23/03/19.
//  Copyright © 2019 hyperionStudios. All rights reserved.
//

import Cocoa

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    @IBAction func donationButtonPressed(_ sender: Any) {
        NSWorkspace.shared.open(URL(string:"https://www.paypal.me/thelucifer0509/USD1.5")!)
    }
    
}

