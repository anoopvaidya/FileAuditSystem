//
//  main.m
//  FileAuditSystemExtension
//
//  Created by Anoop Vaidya on 01/05/23.
//
// This runs, gets the Notifications for the application events, but I don't know how to get for files!
// Hence commented the WIP code, if in future I learn I will complete it.

#import <Foundation/Foundation.h>
#include <EndpointSecurity/EndpointSecurity.h>
#include <dispatch/dispatch.h>
#include <bsm/libbsm.h>
#include <stdio.h>
#include <os/log.h>

NSString* convert(es_string_token_t* stringToken){
    return [[NSString alloc] initWithBytes:stringToken->data length:stringToken->length encoding:NSUTF8StringEncoding];
}

static void handleEvent(es_client_t *client, const es_message_t *msg)
{
//    char const *filePath = msg->process->executable->path.data;
//    NSString *filePathString = [[NSString alloc] initWithFormat:@"%s", filePath];
    
    
    if (msg->event_type == ES_EVENT_TYPE_NOTIFY_OPEN) {
        char const *fn = msg->event.open.file->path.data;
        NSString *fnstr = [[NSString alloc] initWithFormat:@"%s", fn];
        
        os_log(OS_LOG_DEFAULT, "open %@", fnstr);
    }
    else if (msg->event_type == ES_EVENT_TYPE_NOTIFY_CLOSE) {
        char const *fn = msg->event.open.file->path.data;
        NSString *fnstr = [[NSString alloc] initWithFormat:@"%s", fn];
        
        os_log(OS_LOG_DEFAULT, "close %@", fnstr);
    }
    else if (msg->event_type == ES_EVENT_TYPE_NOTIFY_WRITE) {
        char const *fn = msg->event.open.file->path.data;
        NSString *fnstr = [[NSString alloc] initWithFormat:@"%s", fn];
        
        os_log(OS_LOG_DEFAULT, "close %@", fnstr);
    }
    else if (msg->event_type == ES_EVENT_TYPE_NOTIFY_CREATE) {
        es_message_t *message = msg;
        NSString *fn = convert( &message->event.create.destination.new_path.filename);
        NSString *fnstr = [[NSString alloc] initWithFormat:@"%@", fn];
        
        os_log(OS_LOG_DEFAULT, "open %@", fnstr);
    }
    else {
        os_log(OS_LOG_DEFAULT, "something else");
    }
    
    
//    if (msg->event.rename.destination_type == ES_DESTINATION_TYPE_NEW_PATH)
//    {
//        os_log(OS_LOG_DEFAULT, "renamed");
//    }
    
//    os_log(OS_LOG_DEFAULT, "1 = %@", msg);
//    os_log(OS_LOG_DEFAULT, "2 = %u", msg->action_type);
//
//
    
//    if ([filePathString hasPrefix: @"/Users/anoopvaidya"]) {
//        os_log(OS_LOG_DEFAULT, "filePathString = %@", filePathString);
//
//    }
        
//    NSString* string = [NSString stringWithUTF8String:[[NSData dataWithBytes:stringToken->data.length:stringToken->length] bytes]];
    
    
    // TODO: need to check the user who logged in, is this possible?
//    NSString *path = [NSString stringWithFormat:@"/Users/%@/Documents", @"anoopvaidya"];

//    os_log(OS_LOG_DEFAULT, "filePathString = %@, path = %@", filePathString, path);
//
//    // check if the events are from path
//    if ([filePathString hasPrefix:path]) {
//        os_log(OS_LOG_DEFAULT, "Compare - filePathString = %@, path = %@", filePathString, path);
//        os_log(OS_LOG_DEFAULT, "proceeding...");
//    }
//    else {
//        return;
//    }
    
//    switch (msg->event_type) {
//        case ES_EVENT_TYPE_NOTIFY_EXEC:
//            os_log(OS_LOG_DEFAULT, "%{public}s (pid: %d) | EXEC: New image: %{public}s",
//                msg->process->executable->path.data,
//                audit_token_to_pid(msg->process->audit_token),
//                msg->event.exec.target->executable->path.data);
//            break;
//
//        case ES_EVENT_TYPE_NOTIFY_FORK:
//            os_log(OS_LOG_DEFAULT, "%{public}s (pid: %d) | FORK: Child pid: %d",
//                msg->process->executable->path.data,
//                audit_token_to_pid(msg->process->audit_token),
//                audit_token_to_pid(msg->event.fork.child->audit_token));
//            break;
//
//        case ES_EVENT_TYPE_NOTIFY_EXIT:
//            os_log(OS_LOG_DEFAULT, "%{public}s (pid: %d) | EXIT: status: %d",
//                msg->process->executable->path.data,
//                audit_token_to_pid(msg->process->audit_token),
//                msg->event.exit.stat);
//            break;
//
//        case   ES_EVENT_TYPE_NOTIFY_OPEN:
//            os_log(OS_LOG_DEFAULT, "Open event");
//            break;
//        case ES_EVENT_TYPE_NOTIFY_CLOSE:
//            os_log(OS_LOG_DEFAULT, "Close event");
//
//            break;
//
//        default:
//            os_log_error(OS_LOG_DEFAULT, "Unexpected event type encountered: %d\n", msg->event_type);
//            break;
//    }
}

void mutePath(es_client_t *client) {
    os_log(OS_LOG_DEFAULT,"Adding muted files list");
    
    NSArray<NSString *> *paths = @[
        @"/Applications/",
        @"/bin/",
        @"/cores/",
        @"/dev/",
        @"/Library/",
        @"/opt/",
        @"/private/",
        @"/sbin/",
        @"/System/",
        @"/usr/",
        @"/var/",
    ];
    
    for (NSString *path in paths) {
        es_mute_path_prefix(client, [path UTF8String]);
    }
}

int main(int argc, char *argv[])
{
    // Create the client
    es_client_t *client = NULL;
    
    es_new_client_result_t newClientResult = es_new_client(&client, ^(es_client_t *c, const es_message_t *message) {
        handleEvent(client, message);
    });

    if (newClientResult != ES_NEW_CLIENT_RESULT_SUCCESS) {
        return 1;
    }
    
    mutePath(client);
    
    es_event_type_t events[] = {
        ES_EVENT_TYPE_NOTIFY_CREATE, //create file
        ES_EVENT_TYPE_NOTIFY_OPEN, // open file
        ES_EVENT_TYPE_NOTIFY_RENAME, // rename file
        ES_EVENT_TYPE_NOTIFY_CLOSE, // close file
        ES_EVENT_TYPE_NOTIFY_WRITE, // write to file
        ES_EVENT_TYPE_NOTIFY_UNLINK, // delete
        ES_EVENT_TYPE_NOTIFY_EXIT
    };
    
    if (es_subscribe(client, events, sizeof(events) / sizeof(events[0])) != ES_RETURN_SUCCESS) {
        os_log(OS_LOG_DEFAULT, "Failed to subscribe to events");
        es_delete_client(client);
        return 1;
    }

    dispatch_main();
    
    return 0;
}
