//
//  main.swift
//  FileAuditSystemExtension
//
//  Created by Anoop Vaidya on 29/04/23.
//

import Foundation
import EndpointSecurity
import OSLog

var client: OpaquePointer?


//handle_event(es_client_t *client, const es_message_t *msg)
func handleEvent() {
    
}

//func parseWriteNotification(esMessage: es_message_t) -> EndpointSecurityFileChangeNotification? {
//    let filePath = getFilePath(file: esMessage.event.write.target.pointee)
//
//    let parsedMessage = EndpointSecurityFileChangeNotification(type: EndpointSecurityFileChangeNotificationType.write,
//                                                               pathList: [filePath])
//
//    return parsedMessage
//}

func getFilePath(file: es_file_t) -> String {
    return String(cString: file.path.data!)
}


// Create the client
let result = es_new_client(&client) { (client, message) in
    // Do processing on the message received
    print("client is \(client) and message is \(message)")
    //NSLog("Anay testing...message: %@, from client", message.pointee.event_type)
    
//    var messageOpt: EndpointSecurityFileChangeNotification?
    
    switch message.pointee.event_type {
    case ES_EVENT_TYPE_NOTIFY_EXEC:
//        os_log("%{public}s (pid: %d) | EXEC: New image: %{public}s",
//               message.pointee.process.pointee.executable.pointee.path.data,
//               audit_token_to_pid(message.pointee.process.pointee.audit_token),
//               message.pointee.event.exec.target.pointee.executable.pointee.path.data);
        os_log("Something here")
        
        let filePath = getFilePath(file: message.pointee.event.write.target.pointee)
        os_log("1 FilePath: %@", filePath)
        os_log("2 FilePath %{public}@ ", type: .info, filePath)

        
//        var msg = parseExecNotification(esMessage: message.pointee)

    default:
        os_log("Nothing here")
    }
}

NSLog("Anay 4")

if result != ES_NEW_CLIENT_RESULT_SUCCESS {
    print("exit failure of es client")
    exit(EXIT_FAILURE)
}

if let client = client {
    os_log("Connected to endpoint security subsystem.")
    
    var events = [ES_EVENT_TYPE_NOTIFY_EXEC, ES_EVENT_TYPE_NOTIFY_FORK, ES_EVENT_TYPE_NOTIFY_EXIT]
    let result = es_subscribe(client, &events, UInt32(events.count))
    if result != ES_RETURN_SUCCESS {
        os_log("Failed to subscribe", type: .error)
    } else {
        os_log("Subscribed", type: .info)
    }
}

dispatchMain()
