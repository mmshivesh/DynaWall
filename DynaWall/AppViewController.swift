//
//  ViewController.swift
//  DynaWall
//
//  Created by Shivesh M M on 23/03/19.
//  Copyright © 2019 hyperionStudios. All rights reserved.
//


import Cocoa

class AppViewController: NSViewController,NSTableViewDataSource, NSTableViewDelegate, NSWindowDelegate, NSUserNotificationCenterDelegate {
   
    
    @IBOutlet weak var loadingInfoStack: NSStackView!
    @IBOutlet weak var loadingMessageLabel: NSTextField!
    @IBOutlet weak var loadingTableSpinner: NSProgressIndicator!
    
    @IBOutlet weak var loadingSpinner: NSProgressIndicator!
    @IBOutlet weak var addPhotoSegment: NSSegmentedControl!
    @IBOutlet weak var createHEICimage: NSButton!
    @IBOutlet weak var imageWell: NSImageView!
    @IBOutlet weak var pathTable: NSTableView!
    
    @objc dynamic var pathArrays:[tableCellDataModel] = []
    
    var addingToEmptyTable = true
    var currentRow:Int = 0
    var numberOfPhotosRemaining = 16
    var darkButtonArray: [NSButton] = []
    var lightButtonArray: [NSButton] = []
    var finalSavePath: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSUserNotificationCenter.default.delegate = self
        pathTable.delegate = self
        pathTable.dataSource = self
        addPhotoSegment.setEnabled(false, forSegment: 1)
        createHEICimage.isEnabled = false
        createHEICimage.title = "Add " + String(numberOfPhotosRemaining) + " images"
        loadingSpinner.isHidden = true
        loadingInfoStack.isHidden = true

//        loadingInfoStack.layer?
        // MARK: If the userDefaults is not set for the download location and the mode of obtaining the time zones, set the defaults
        
//        let dl = UserDefaults()
//        if dl.url(forKey: "downloadLocation") == nil {
//            dl.set(NSHomeDirectory() + "/" + "Downloads", forKey: "downloadLocation")
//        }
//        else {
//            SavePath = dl.url(forKey: "downloadLocation")
//        }
//        if dl.string(forKey: "modeSelect") == nil {
//            dl.set("Automatic", forKey: "modeSelect")
//        }
        
    }
    // MARK: Change title of create wallpaper button
    
    override func viewDidAppear() {
        self.view.window?.delegate = self
    }
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }
    
    // MARK: Notification stuff
    func showNotification(forImageURL image:URL?) {
        let doneNotification = NSUserNotification()
        doneNotification.title = "DynaWall"
        doneNotification.subtitle = "Your Wallpaper is ready!"
        doneNotification.informativeText = "Saved in Folder \"\(image?.pathComponents.dropLast().last! ?? "your folder")\""
        doneNotification.contentImage = NSImage.init(contentsOf: image!)
        doneNotification.hasActionButton = true
        doneNotification.soundName = NSUserNotificationDefaultSoundName
        doneNotification.otherButtonTitle = "Dismiss"
        doneNotification.actionButtonTitle = "More"
        var actions = [NSUserNotificationAction]()
        
        let action1 = NSUserNotificationAction(identifier: "action1", title: "Set as Wallpaper")
        let action2 = NSUserNotificationAction(identifier: "action2", title: "Show in Finder")
        
        actions.append(action1)
        actions.append(action2)
        
        
        doneNotification.additionalActions = actions
        
        doneNotification.setValue(true, forKey: "_alwaysShowAlternateActionMenu")
        let notificationCenter = NSUserNotificationCenter.default
        notificationCenter.deliver(doneNotification)
    }
    
    public func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        
        print("Yup!")
        switch notification.activationType {
        case .additionalActionClicked:
            guard let title = notification.additionalActivationAction?.title else {return}
            print("Clicked \(title)")
            if notification.additionalActivationAction?.identifier == "action1" {
                print("Setting Wallpaper...")
                try! NSWorkspace.shared.setDesktopImageURL(finalSavePath!, for: NSScreen.main!, options: [:])
            }
            else {
                NSWorkspace.shared.activateFileViewerSelecting([finalSavePath!])
                
            }
        case .actionButtonClicked:
            print("Action button ")
        case .contentsClicked:
            NSWorkspace.shared.activateFileViewerSelecting([finalSavePath!])
        default:
            return
        }
    }
    
    func changeCreateButtonTitle() {
        if numberOfPhotosRemaining == 0 {
            createHEICimage.title = "Create Wallpaper"
            createHEICimage.isEnabled = true
            addPhotoSegment.setEnabled(false, forSegment: 0)
        }
        else if numberOfPhotosRemaining != 1 {
            createHEICimage.title = "Add " + String(numberOfPhotosRemaining) + " Images"
            createHEICimage.isEnabled = false
            addPhotoSegment.setEnabled(true, forSegment: 0)
        }
        else {
            createHEICimage.title = "Add " + String(numberOfPhotosRemaining) + " Image"
            createHEICimage.isEnabled = false
            addPhotoSegment.setEnabled(true, forSegment: 0)
        }
    }
    
    // MARK: "Create Wallpaper" button is pressed
    func saveFinalImageAsync(_ url: URL?) {
        let objectCreator = DefaultGenerator(pathList: pathArrays, baseURL: (url?.deletingLastPathComponent())!, outputFileName: url!.lastPathComponent, loadingSpinner: self.loadingTableSpinner)
        do {
            try objectCreator.run()
        } catch let error {
            print(error)
        }
    }
    @IBAction func createButtonPressed(_ sender: Any) {
        let savePanel = NSSavePanel()
//        savePanel.directoryURL = SavePath
        savePanel.title = "Save File"
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.nameFieldStringValue = "Output.heic"
        savePanel.allowedFileTypes = ["heic"]
        
        if (savePanel.runModal() == .OK) {
            finalSavePath = savePanel.url
            loadingMessageLabel.stringValue = "Saving Image..."
            loadingInfoStack.isHidden = false
            loadingTableSpinner.usesThreadedAnimation = true
            loadingTableSpinner.startAnimation(self)
            DispatchQueue.global(qos: .background).async {
                self.saveFinalImageAsync(savePanel.url)
                DispatchQueue.main.async {
                    self.loadingTableSpinner.stopAnimation(self)
                    self.loadingInfoStack.isHidden = true
                    self.showNotification(forImageURL: savePanel.url)
                }
            }
        }
    }
    
    // MARK: Action to control +/- Segmented control click and to enable/disable '-'
    func loadAsync(withUrls urls: [URL]) {
        for i in urls {
//            var firstImagePrimary = false
//            // TODO: Robust fix needed
//            if currentRow == 0 {
//                firstImagePrimary = true
//            }
            let image = NSImage(contentsOf: i)!
            let isLight = image.averageColor!.isLight()!
            DispatchQueue.main.async {
                let newRow = tableCellDataModel(row: self.currentRow+1, fileName: i, isPrimary: false, isForDark: !isLight, isForLight: isLight, altitude:0.0, azimuth: 0.0)
                self.pathArrays.append(newRow)
                self.currentRow+=1
                self.numberOfPhotosRemaining-=1
            }
        }
        
    }
    func setupLoadAsync(urls: [URL]) {
        pathTable.isEnabled = false
        loadingMessageLabel.stringValue = "Loading Images..."
        loadingInfoStack.isHidden = false
        loadingTableSpinner.usesThreadedAnimation = true
        loadingTableSpinner.startAnimation(self)
        DispatchQueue.global(qos:.background).async {
            self.loadAsync(withUrls: urls)
            DispatchQueue.main.async {
                self.changeCreateButtonTitle()
                self.pathTable.isEnabled = true
                self.loadingTableSpinner.stopAnimation(self)
                self.loadingInfoStack.isHidden = true
                if !self.pathArrays[0].isPrimary {
                    self.pathArrays[0].isPrimary = true
                }
                if self.addingToEmptyTable {
                    let indexSet = IndexSet(integer: 0)
                    self.pathTable.selectRowIndexes(indexSet, byExtendingSelection: false)
                    self.addingToEmptyTable = false
                }
            }
        }
    }
    @IBAction func segmentedControlClick(_ sender: Any) {
//        if pathArrays.count == 16 {
//            createHEICimage.isEnabled = true
//        }
//        else {
//            createHEICimage.isEnabled = false
//        }
        if addPhotoSegment.indexOfSelectedItem == 0 {
            let dialog = NSOpenPanel()
            dialog.title = "Select Image file(s)"
            dialog.canChooseDirectories = false
            dialog.canChooseFiles = true
            dialog.allowsMultipleSelection = true
            dialog.showsHiddenFiles = false
            dialog.allowedFileTypes = ["jpg","png","tiff"]
            if (dialog.runModal() == .OK)
            {
                if numberOfPhotosRemaining < dialog.urls.count {
                    print("Count Exceeds 16")
                    let cutTillTheRemaining = Array(dialog.urls[0..<numberOfPhotosRemaining])
                    print(cutTillTheRemaining)
                    // Load the cutTillTheRemaining array instead of dialog.urls
                    setupLoadAsync(urls: cutTillTheRemaining)
                }
                else {
                    setupLoadAsync(urls: dialog.urls)
                }
                
                // MARK: Enable '-' Segment if disabled
                if !addPhotoSegment.isEnabled(forSegment: 1) {
                    addPhotoSegment.setEnabled(true, forSegment: 1)
                }
                // If you diligently add 16 images in one go
                if pathArrays.count == 16 {
                    createHEICimage.isEnabled = true
                    addPhotoSegment.setEnabled(false, forSegment: 0)
                }
                pathTable.reloadData()
            }
        }
        else {
            print("To remove row index " + String(pathTable.selectedRow))
            let selectedRow = pathTable.selectedRow
            if selectedRow == -1 {
                    return
            }
            pathArrays.remove(at: selectedRow)
            currentRow-=1
            numberOfPhotosRemaining+=1
            changeCreateButtonTitle()
            fixRowNumbers()
            if pathArrays.count == 0 {
                addPhotoSegment.setEnabled(false, forSegment: 1)
                imageWell.image = nil
                addingToEmptyTable = true
            }
            pathTable.reloadData()
            loadingSpinner.startAnimation(self.view)
            let indexSet = IndexSet(integer: selectedRow-1)
            pathTable.selectRowIndexes(indexSet, byExtendingSelection: false)
            
        }
    }
    
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        let helpButton = sender as! NSButton
        let popover = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "HelpViewController") as! NSViewController
        self.present(popover, asPopoverRelativeTo: helpButton.bounds, of: helpButton, preferredEdge: NSRectEdge.minY, behavior: .transient)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return pathArrays.count
    }
    
    @IBAction func darkCheckBoxPressed(_ sender: Any) {
        let senderButton = sender as! NSButton
        let buttonRow = senderButton.superview?.superview as! NSTableRowView
        let orderCol = buttonRow.view(atColumn: 0) as! NSTableCellView
        let orderValue = Int((orderCol.subviews[0] as! NSTextField).stringValue)
        for row in pathArrays {
            if row.rowidx == orderValue {
                row.setDark()
            }
        }
    }
    @IBAction func lightCheckBoxPressed(_ sender: Any) {
        let senderButton = sender as! NSButton
        let buttonRow = senderButton.superview?.superview as! NSTableRowView
        let orderCol = buttonRow.view(atColumn: 0) as! NSTableCellView
        let orderValue = Int((orderCol.subviews[0] as! NSTextField).stringValue)
        for row in pathArrays {
            if row.rowidx == orderValue {
                row.setLight()
            }
        }
    }
    @IBAction func radioPressed(_ sender: Any  ) {
        // MARK: Deselect all other radio buttons by getting the first column value of the selected button and modifying the pathArrays variable
        let senderButton = sender as! NSButton
        let buttonRow = senderButton.superview?.superview as! NSTableRowView
        let orderCol = buttonRow.view(atColumn: 0) as! NSTableCellView
        let orderValue = Int((orderCol.subviews[0] as! NSTextField).stringValue)
        for row in pathArrays {
            if row.rowidx != orderValue {
                row.isPrimary = false
            }
        }
    }
    func fixRowNumbers() {
        for (idx,i) in pathArrays.enumerated() {
            i.rowidx = idx+1
        }
    }
    func updateImagePreview(forRowPath row: Int)
    {
        // TODO: Clear the image well when all the images have been deleted
        var image:NSImage!
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.pathArrays.isEmpty && row != -1 {
                image = NSImage(contentsOf: self.pathArrays[row].getUrl())
            }
            DispatchQueue.main.async {
                self.loadingSpinner.stopAnimation(self.view)
                self.loadingSpinner.isHidden = true
                if self.pathArrays.count == 0 {
                    self.imageWell.image = nil
                    return
                }
                else if row == self.pathArrays.count {
                    self.imageWell.image = nil
                    return
                }
                else {
                    self.imageWell.image = image
                }
            }
        }
    }
    func tableViewSelectionDidChange(_ notification: Notification) {
        imageWell.image = nil
        loadingSpinner.isHidden = false
        loadingSpinner.startAnimation(self.view)
        updateImagePreview(forRowPath:  pathTable.selectedRow)
    }
}
