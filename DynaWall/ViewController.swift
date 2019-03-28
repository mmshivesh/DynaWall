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
    
    @IBOutlet weak var addPhotoSegment: NSSegmentedControl!
    @IBOutlet weak var createHEICimage: NSButton!
    @IBOutlet weak var imageWell: NSImageView!
    @IBOutlet weak var pathTable: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pathTable.delegate = self
        pathTable.dataSource = self
        addPhotoSegment.setEnabled(false, forSegment: 1)
        
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
        
    }
    
    // MARK: Action to control +/- Segmented control click and to enable/disable '-'
    
    @IBAction func segmentedControlClick(_ sender: Any) {
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
                for i in dialog.urls {
                    let newRow = tableCellDataModel(row: currentRow, fileName: i, isForDark: false, isForLight: false)
                    pathArrays.append(newRow!)
                    currentRow+=1
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
        }
        else {
            print("To remove row index " + String(pathTable.selectedRow))
            let selectedRow = pathTable.selectedRow
            if selectedRow == -1 {
                    return
            }
            pathArrays.remove(at: selectedRow)
            if pathArrays.count == 0 {
                addPhotoSegment.setEnabled(false, forSegment: 1)
            }
            pathTable.reloadData()
            updateImagePreview(forRowPath: selectedRow)
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return pathArrays.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        if tableColumn!.title == "Images" {
            return pathArrays[row].getUrl().lastPathComponent
        }
        else {
            return row+1
        }
    }
    func updateImagePreview(forRowPath row: Int)
    {
        if pathArrays.count == 0 {
            imageWell.image = nil
            return
        }
        else if row == pathArrays.count {
            imageWell.image = nil
            return
        }
        else {
            imageWell.image = NSImage(contentsOf: pathArrays[row].getUrl())
        }
        
    }
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateImagePreview(forRowPath:  pathTable.selectedRow)
    }
}
