//
//  HelpViewController.swift
//  DynaWall
//
//  Created by Shivesh M M on 5/21/19.
//  Copyright © 2019 hyperionStudios. All rights reserved.
//

import Cocoa

class HelpViewController: NSViewController {

    @IBAction func closeButtonPressed(_ sender: Any) {
        self.view.window?.performClose(sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
