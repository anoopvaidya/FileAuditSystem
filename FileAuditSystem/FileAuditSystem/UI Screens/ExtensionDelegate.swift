//
//  ExtensionDelegate.swift
//  FileAuditSystem
//
//  Created by Anoop Vaidya on 29/04/23.
//

import Foundation
import SystemExtensions

enum ExtensionInstallStatus {
    case Success
    case Fail
    case InProgress
}

class ExtensionDelegate : NSObject, OSSystemExtensionRequestDelegate{
    
    var status: ExtensionInstallStatus = .InProgress
    
    func request(_ request: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
        
        print("Sext actionForReplacingExtension \(existing) : \(ext)")
        status = .InProgress
        return .replace
    }
    
    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        print("Sext needsUserApproval")
        status = .InProgress
    }
    
    func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
        print("Sext didFinishWithResult \(result.rawValue)")
        Thread.sleep(forTimeInterval: 3)
        status = .Success
    }
    
    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
        print("Sext didFailWithError \(error.localizedDescription)")
        status = .Fail
    }
}
