//
//  AppDelegate.swift
//  FileAuditSystem
//
//  Created by Anoop Vaidya on 29/04/23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    
    let folderManageVC = FolderManageViewController()
    let checkSextVC = CheckExtensionViewController()

    func isExtensionUpAndRunning() -> Bool {
        return true;
    }
    
        
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if isExtensionUpAndRunning() {
            self.window.contentView?.addSubview(folderManageVC.view)
        }
        else {
            self.window.contentView?.addSubview(checkSextVC.view)
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

