//
//  main.swift
//  Extension
//
//  Created by Anoop Vaidya on 29/04/23.
//

import Foundation
import EndpointSecurity

var client: OpaquePointer?

// Create the client
let res = es_new_client(&client) { (client, message) in
    // Do processing on the message received
    
    print(client)
    print(message)
}

if res != ES_NEW_CLIENT_RESULT_SUCCESS {
    exit(EXIT_FAILURE)
}

dispatchMain()
