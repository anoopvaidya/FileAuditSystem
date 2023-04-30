//
//  main.swift
//  FileAuditSystemExtension
//
//  Created by Anoop Vaidya on 29/04/23.
//

import Foundation
import EndpointSecurity

var client: OpaquePointer?

NSLog("Hello Anay 3")


//handle_event(es_client_t *client, const es_message_t *msg)
func handleEvent() {
    
}



// below came from template
// Create the client
let res = es_new_client(&client) { (client, message) in
    // Do processing on the message received
    print("client is \(client) and message is \(message)")
    //NSLog("Anay testing...message: %@, from client", message.pointee.event_type)

    NSLog("Anay :) done")
}

NSLog("Anay 4")

if res != ES_NEW_CLIENT_RESULT_SUCCESS {
    print("exit failure of es client")
    NSLog("Anay 5")
    exit(EXIT_FAILURE)
}

NSLog("Anay 6")

dispatchMain()
