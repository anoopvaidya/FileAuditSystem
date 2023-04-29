//
//  CheckExtensionViewController.swift
//  FileAuditSystem
//
//  Created by Anoop Vaidya on 29/04/23.
//

import Cocoa
import SystemExtensions


class CheckExtensionViewController: NSViewController {

    let extIdentifier = "com.anoop.FileAuditSystem.Extension"
    let extensionDelegate = ExtensionDelegate()

    var isRequested = false
    
    @IBAction func install(_ sender: Any) {
        if isRequested  {
            print("Active Request")
            return
        }
        let request = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extIdentifier, queue: DispatchQueue.main)
        request.delegate = extensionDelegate
        OSSystemExtensionManager.shared.submitRequest(request)
        isRequested = true
        print("Sext request submitted")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
