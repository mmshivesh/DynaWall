//
//  PreferencesViewController.swift
//  DynaWall
//
//  Created by Shivesh M M on 26/03/19.
//  Copyright © 2019 hyperionStudios. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController{

    var modeSelect: String = "Automatic"
    
    @IBOutlet weak var automaticButton: NSButton!
    @IBOutlet weak var customButton: NSButton!

    @IBOutlet weak var timeTableView: NSTableView!
    
    @IBOutlet weak var automaticLocationStack: NSStackView!
    @IBOutlet weak var stackLocation: NSTextField!
    
    @IBOutlet weak var getLocationButton: NSButton!
    
    
    @IBAction func getLocationButtonPressed(_ sender: Any) {
        // TODO: Custom implementation
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Permanently enabling automatic for now.
        automaticButton.state = .on
    }
    
    func enableAutomaticAndDisableCustom() {
        automaticLocationStack.layer?.opacity = 0.3
        getLocationButton.isEnabled = false
        timeTableView.layer?.opacity = 0.3
        timeTableView.isEnabled = false
        
    }
    func disableAutomaticAndEnableCustom() {
        automaticLocationStack.layer?.opacity = 1.0
        getLocationButton.isEnabled = true
        timeTableView.layer?.opacity = 1.0
        timeTableView.isEnabled = true
    }
    
    override func viewWillAppear() {
        //        let dl = UserDefaults()
        //        let downloadLocation = dl.url(forKey: "downloadLocation")
        //        fileLocationButton.title = downloadLocation!.lastPathComponent
        //        modeSelect = dl.string(forKey: "modeSelect")!
    }
    override func viewDidLayout() {
//        if modeSelect == "Automatic" {
//            automaticButton.state = .on
//            customButton.state = .off
//            enableAutomaticAndDisableCustom()
//        }
//        else {
//            automaticButton.state = .off
//            customButton.state = .on
//            disableAutomaticAndEnableCustom()
//        }
        // MARK: Disabling Custom for now.
        automaticLocationStack.layer?.opacity = 0.3
        customButton.isEnabled = false
        getLocationButton.isEnabled = false
        timeTableView.layer?.opacity = 0.3
        timeTableView.isEnabled = false
    }
//    @IBAction func fileLocationButtonPressed(_ sender: Any) {
//        let dialog = NSOpenPanel()
//        dialog.title = "Select Destination Folder"
//        dialog.canChooseDirectories = true
//        dialog.canChooseFiles = false
//        dialog.allowsMultipleSelection = false
//        dialog.showsHiddenFiles = false
//        if (dialog.runModal() == .OK) {
//            let destination = dialog.url
//            fileLocationButton.title = destination!.lastPathComponent
//            let dl = UserDefaults()
//            dl.set(destination, forKey: "downloadLocation")
//        }
//        
//    }
    @IBAction func radioButtonAction(_ sender: Any) {
//        let dl = UserDefaults()
//        // Force typecast as a button
//        let button = sender as! NSButton
//        if button.title == "Automatic" {
//            enableAutomaticAndDisableCustom()
//            dl.set("Automatic", forKey: "modeSelect")
//        }
//        else {  // "Custom" button selected
//            disableAutomaticAndEnableCustom()
//            dl.set("Custom", forKey: "modeSelect")
//        }
    }
    @IBAction func donationButtonPressed(_ sender: Any) {
        NSWorkspace.shared.open(URL(string:"https://www.paypal.me/thelucifer0509/USD")!)
    }
    
    @IBAction func automaticHelpButtonPressed(_ sender: Any) {
        let helpButton = sender as! NSButton
        let automaticPopover = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "AutomaticViewController") as! NSViewController
        self.present(automaticPopover, asPopoverRelativeTo: helpButton.bounds, of: helpButton, preferredEdge: .minY, behavior: .semitransient)
    }
    
    @IBAction func customHelpButtonPressed(_ sender: Any) {
        let helpButton = sender as! NSButton
        let automaticPopover = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "CustomViewController") as! NSViewController
        self.present(automaticPopover, asPopoverRelativeTo: helpButton.bounds, of: helpButton, preferredEdge: .minY, behavior: .semitransient)
    }
}
