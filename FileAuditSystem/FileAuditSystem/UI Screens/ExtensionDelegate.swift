//
//  ExtensionDelegate.swift
//  FileAuditSystem
//
//  Created by Anoop Vaidya on 29/04/23.
//

import Foundation
import SystemExtensions

class ExtensionDelegate : NSObject, OSSystemExtensionRequestDelegate{
    
    static let shared = ExtensionDelegate()
    
    func request(_ request: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
        
        print("Sext actionForReplacingExtension \(existing) : \(ext)")
        return .replace
    }
    
    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        print("Sext needsUserApproval")
    }
    
    func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
        print("Sext didFinishWithResult \(result.rawValue)")
    }
    
    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
        print("Sext didFailWithError \(error.localizedDescription)")
    }
}
