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
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

