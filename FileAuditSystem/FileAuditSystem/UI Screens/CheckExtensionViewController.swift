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
    
    
    // The below is for Testing the Logger by supplying user given test data.
    // Once the File Monitoring/Events are done, this should be deleted.
    
    @IBOutlet var fileName: NSTextField!
    @IBOutlet var operation: NSTextField!
    @IBOutlet var processId: NSTextField!
    
    @IBAction func addRecord(_ sender: Any) {
                
        let logObject = LogObject(fileName: fileName.stringValue,
                                   time: Date(),
                                  userName: NSFullUserName(),
                                   processId: processId.stringValue,
                                   accessType: getAccessType())
        
        
        if Logger.log(logObject: logObject) {
            print("Succeed to log")
        }
        else {
            print("Failed to log")
        }
        
    }
    
    func getAccessType() -> AccessType{
        switch operation.stringValue {
        case "c":
            return .Create
        case "u":
            return .Update
        case "r":
            return .Read
        case "d":
            return .Delete
        default:
            return .Delete
        }
    }
}
