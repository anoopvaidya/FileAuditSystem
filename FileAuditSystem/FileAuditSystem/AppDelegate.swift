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
    
    let folderManageViewController = FolderManageViewController()
    let checkSysExtViewController = CheckExtensionViewController()
    
    func isExtensionUpAndRunning() -> Bool {
        // TODO: in future- check if SysExt is alreay running
        // as of now always return false, as not running, let user manually install every time app runs
        return false;
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if isExtensionUpAndRunning() {
            self.window.contentView?.addSubview(folderManageViewController.view)
        }
        else {
            self.window.contentView?.addSubview(checkSysExtViewController.view) //sext
            checkSysExtViewController.installerDelegate = self
        }
    }
    
    func extensionInstalled() {
        checkSysExtViewController.view.removeFromSuperview()
        self.window.contentView?.addSubview(folderManageViewController.view)
    }
}

