//
//  ViewController.swift
//  DynaWall
//
//  Created by Shivesh M M on 23/03/19.
//  Copyright © 2019 hyperionStudios. All rights reserved.
//


import Cocoa

class ViewController: NSViewController,NSTableViewDataSource, NSTableViewDelegate {
    var pathArrays:[tableCellDataModel] = []
//    var urlArray:[URL] = []
    var currentRow:Int = 0
    var numberOfPhotosRemaining = 16
    
    @IBOutlet weak var loadingSpinner: NSProgressIndicator!
    @IBOutlet weak var addPhotoSegment: NSSegmentedControl!
    @IBOutlet weak var createHEICimage: NSButton!
    @IBOutlet weak var imageWell: NSImageView!
    @IBOutlet weak var pathTable: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pathTable.delegate = self
        pathTable.dataSource = self
        addPhotoSegment.setEnabled(false, forSegment: 1)
        createHEICimage.isEnabled = false
        createHEICimage.title = "Add " + String(numberOfPhotosRemaining) + " images"
        loadingSpinner.isHidden = true
        // MARK: If the userDefaults is not set for the download location and the mode of obtaining the time zones, set the defaults
        
        let dl = UserDefaults()
        if dl.url(forKey: "downloadLocation") == nil {
            dl.set(NSHomeDirectory() + "/" + "Downloads", forKey: "downloadLocation")
        }
        if dl.string(forKey: "modeSelect") == nil {
            dl.set("Automatic", forKey: "modeSelect")
        }
        
    }
    
    // MARK: "Create Wallpaper" button is pressed
    
    @IBAction func createButtonPressed(_ sender: Any) {
        for i in 0..<currentRow{
            print(pathArrays[i].rowidx)
        }
    }
    
    // MARK: Action to control +/- Segmented control click and to enable/disable '-'
    
    @IBAction func segmentedControlClick(_ sender: Any) {
        if pathArrays.count == 16 {
            createHEICimage.isEnabled = true
        }
        else {
            createHEICimage.isEnabled = false
        }
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
                }
                else {
                    for i in dialog.urls {
                        let newRow = tableCellDataModel(row: currentRow, fileName: i, isForDark: false, isForLight: false)
                        pathArrays.append(newRow!)
                        currentRow+=1
                        numberOfPhotosRemaining-=1
                    }
                    if numberOfPhotosRemaining != 1 {
                        createHEICimage.title = "Add " + String(numberOfPhotosRemaining) + " Images"
                    }
                    else {
                        createHEICimage.title = "Add " + String(numberOfPhotosRemaining) + " Image"
                    }
                }
                // MARK: Enable '-' Segment if disabled
                if !addPhotoSegment.isEnabled(forSegment: 1) {
                    addPhotoSegment.setEnabled(true, forSegment: 1)
                }
                pathTable.reloadData()
            }
            else
            {
                print("No File selected")
            }
//            print(currentRow)
        }
        else {
            print("To remove row index " + String(pathTable.selectedRow))
            let selectedRow = pathTable.selectedRow
            if selectedRow == -1 {
                    return
            }
            pathArrays.remove(at: selectedRow)
            currentRow-=1
            if pathArrays.count == 0 {
                addPhotoSegment.setEnabled(false, forSegment: 1)
            }
            pathTable.reloadData()
            loadingSpinner.startAnimation(self.view)
            updateImagePreview(forRowPath: selectedRow)
//            print(currentRow)
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return pathArrays.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if pathArrays.count == 16 {
            createHEICimage.isEnabled = true
            createHEICimage.title = "Create Wallpaper"
            addPhotoSegment.setEnabled(false, forSegment: 0)
        }
        else {
            createHEICimage.isEnabled = false
            addPhotoSegment.setEnabled(true, forSegment: 0)
        }
        
        if tableColumn!.title == "Images" {
            return pathArrays[row].getUrl().lastPathComponent
        }
        else {
            return row + 1
        }
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        return
    }
    
    func updateImagePreview(forRowPath row: Int)
    {
        var image:NSImage!
        DispatchQueue.global(qos: .userInitiated).async {
            image = NSImage(contentsOf: self.pathArrays[row].getUrl())
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
