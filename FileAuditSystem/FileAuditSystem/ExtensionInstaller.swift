//
//  ExtensionInstaller.swift
//  FileAuditSystem
//
//  Created by Anoop Vaidya on 30/04/23.
//

import Foundation
import SystemExtensions

class ExtensionInstaller : NSObject {
    
    let extIdentifier = "com.anoop.FileAuditSystem.Extension"

    let extensionDelegate = ExtensionDelegate()
    var installerDelegate: InstallerDelegate?

    
    func install() {
        let request = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: self.extIdentifier, queue: DispatchQueue.main)
        request.delegate = self.extensionDelegate
        OSSystemExtensionManager.shared.submitRequest(request)
        print("Sext install request submitted")
        
        // wait till gets installed, and then proceed to next UI screen
        while self.extensionDelegate.status != .Success {
            print("sext waiting for approval...status is: \(self.extensionDelegate.status)")
        }
        print("sext installed")
    }
    
    
    func uninstall() {
        let request = OSSystemExtensionRequest.deactivationRequest(forExtensionWithIdentifier: self.extIdentifier, queue: DispatchQueue.main)
        request.delegate = self.extensionDelegate
        OSSystemExtensionManager.shared.submitRequest(request)
        print("Sext uninstall request submitted")
    }
    
}
