//
//  main.swift
//  FileAuditSystemExtension
//
//  Created by Anoop Vaidya on 29/04/23.
//

import Foundation
import EndpointSecurity

var client: OpaquePointer?

func startMonitor(message: String) {
    
}


// below came from template
// Create the client
let res = es_new_client(&client) { (client, message) in
    // Do processing on the message received
    print("client is \(client) and message is \(message)")
    NSLog("Anay testing...message: %@, from client %@", message, client)
    
}

if res != ES_NEW_CLIENT_RESULT_SUCCESS {
    print("exit failure of es client")
    exit(EXIT_FAILURE)
}

dispatchMain()
