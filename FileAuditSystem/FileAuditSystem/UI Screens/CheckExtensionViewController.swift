//
//  CheckExtensionViewController.swift
//  FileAuditSystem
//
//  Created by Anoop Vaidya on 29/04/23.
//

import Cocoa
import SystemExtensions


class CheckExtensionViewController: NSViewController {
    var installerDelegate: InstallerDelegate?
    let extensionInstaller = ExtensionInstaller()
    var isRequested = false
    
    @IBAction func install(_ sender: Any) {
        if isRequested  {
            print("Active Request")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.isRequested = true
            self.extensionInstaller.install()
            DispatchQueue.main.async {
                self.installerDelegate?.extensionInstalled()
            }

        }
    }
    
    @IBAction func uninstall(_ sender: Any) {
        self.isRequested = false
        extensionInstaller.uninstall()
    }
}
