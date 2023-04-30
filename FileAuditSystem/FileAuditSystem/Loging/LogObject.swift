//
//  LogObject.swift
//  FileAuditSystem
//
//  Created by Anoop Vaidya on 30/04/23.
//

import Foundation

// This logs file-name, time, Username, ProcessID, AccessType
struct LogObject {
    var fileName: String
    var time: Date
    var userName: String
    var processId: String
    var accessType: AccessType
}
