//
//  AppDelegate.swift
//  FileAuditSystem
//
//  Created by Anoop Vaidya on 29/04/23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, InstallerDelegate {
   
    @IBOutlet var window: NSWindow!
    
    let folderManageVC = FolderManageViewController()
    let checkSextVC = CheckExtensionViewController()
    
    func isExtensionUpAndRunning() -> Bool {
        // TODO: in future, check if alreay running
        // as of now always return false, as not running, let user manually install every time app runs
        return false;
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {        
        if isExtensionUpAndRunning() {
            self.window.contentView?.addSubview(folderManageVC.view)
        }
        else {
            self.window.contentView?.addSubview(checkSextVC.view)
            checkSextVC.installerDelegate = self
        }
    }
    
    func extensionInstalled() {
        print("extension installed")
        checkSextVC.view.removeFromSuperview()
        self.window.contentView?.addSubview(folderManageVC.view)
    }
}

