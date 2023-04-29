//
//  CheckExtensionViewController.swift
//  FileAuditSystem
//
//  Created by Anoop Vaidya on 29/04/23.
//

import Cocoa
import SystemExtensions


class CheckExtensionViewController: NSViewController {

    let extIdentifier = "com.anoop.FileAuditSystem.FileAuditSystemExtension"
    let extensionDelegate = ExtensionDelegate()
    
    let folderManageVC = FolderManageViewController()

    var isRequested = false
    
    @IBAction func install(_ sender: Any) {
        if isRequested  {
            print("Active Request")
            return
        }
        
        // async
        
        DispatchQueue.main.async {
            let request = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: self.extIdentifier, queue: DispatchQueue.main)
            request.delegate = self.extensionDelegate
            OSSystemExtensionManager.shared.submitRequest(request)
            self.isRequested = true
            print("Sext install request submitted")
            
            // wait till gets installed, and then proceed to next UI screen
//            while self.extensionDelegate.status == .InProgress {
//                print("kext waiting for approvals...")
//            }
        }
        
        //main
        print("sext installed")
    }
    
    @IBAction func uninstall(_ sender: Any) {
        let request = OSSystemExtensionRequest.deactivationRequest(forExtensionWithIdentifier: self.extIdentifier, queue: DispatchQueue.main)
        request.delegate = self.extensionDelegate
        OSSystemExtensionManager.shared.submitRequest(request)
        self.isRequested = false
        print("Sext uninstall request submitted")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
