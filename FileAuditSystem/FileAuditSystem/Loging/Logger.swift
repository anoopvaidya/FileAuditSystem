//
//  Logger.swift
//  FileAuditSystem
//
//  Created by Anoop Vaidya on 30/04/23.
//

import Foundation

class Logger: NSObject{
    static let logFileName = "FileAuditSystem.txt"
    
    /// This logs file-name, time, Username, ProcessID, AccessType
    /// returns true if succeed
    static func log(logObject: LogObject) -> Bool {
        
        // if file doesn't exist, create
        // else open the file
        // write new content at the end
      
        let fm = FileManager.default
        
        if let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let filePathUrl = dir.appendingPathComponent(logFileName)
                        
            if fm.fileExists(atPath: filePathUrl.path) {
                print("log file exists")
            }
            else {
                print("log file does not exist, creating one")
                try? "".write(to: filePathUrl, atomically: false, encoding: String.Encoding.utf8)
            }
            
            do {
                let fileHandle = try FileHandle(forWritingTo: filePathUrl)
                fileHandle.seekToEndOfFile()
                fileHandle.write(logObject.description.data(using: .utf8)!)
                fileHandle.closeFile()
            }
            catch {
                
            }
        }
                
        return true;
    }
}



