//
//  FolderManageViewController.swift
//  FileAuditSystem
//
//  Created by Anoop Vaidya on 29/04/23.
//

import Cocoa

class FolderManageViewController: NSViewController {

    @IBOutlet weak var folderPath: NSTextField!
    @IBOutlet weak var folderListText: NSTextField!
    
    let constKey = "trackedFiles"
    
    @IBAction func refreshList(_ sender: Any) {
        var folderNames = ""
        if let folders = UserDefaults.standard.object(forKey: constKey) as? Array<String> {
            for folder in folders.sorted() {
                folderNames.append(folder)
                folderNames.append("\n")
            }
        }
        folderListText.stringValue = folderNames;
    }
    
    @IBAction func addFolder(_ sender: Any) {
        if folderPath.stringValue.isEmpty {
            return
        }
        
        var folderPaths: Array<String> = []
        
        // get all the paths
        if let paths = UserDefaults.standard.object(forKey: constKey) as? Array<String> {
            folderPaths = paths
        }
        
        folderPaths.append(folderPath.stringValue)
        
        let uniquePaths = getUniqueFolderPaths(paths: folderPaths)
        
        UserDefaults.standard.set(uniquePaths, forKey: constKey)
        UserDefaults.standard.synchronize()
        
        folderPath.stringValue = ""
        refreshList(sender)
    }
    
    func getUniqueFolderPaths(paths: Array<String>) -> Array<String> {
        let pathSet = Set<String>(paths)
        return Array(pathSet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshList(self)
    }
}
