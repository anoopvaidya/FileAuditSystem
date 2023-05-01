//
//  main.m
//  FileAuditSystemExtension
//
//  Created by Anoop Vaidya on 01/05/23.
//

#import <Foundation/Foundation.h>
#include <EndpointSecurity/EndpointSecurity.h>
#include <dispatch/dispatch.h>
#include <bsm/libbsm.h>
#include <stdio.h>
#include <os/log.h>

static void handleEvent(es_client_t *client, const es_message_t *msg)
{
    char const *filePath = msg->process->executable->path.data;
    NSString *filePathString = [[NSString alloc] initWithFormat:@"%s", filePath];
    
    // TODO: need to check the user who logged in, is this possible?
    NSString *path = [NSString stringWithFormat:@"/Users/%@/Documents", @"anoopvaidya"];

    os_log(OS_LOG_DEFAULT, "filePathString = %@, path = %@", filePathString, path);
    
    // check if the events are from path
    if ([filePathString hasPrefix:path]) {
        os_log(OS_LOG_DEFAULT, "Compare - filePathString = %@, path = %@", filePathString, path);
        os_log(OS_LOG_DEFAULT, "proceeding...");
    }
    else {
        return;
    }
    
    switch (msg->event_type) {
        case ES_EVENT_TYPE_NOTIFY_EXEC:
            os_log(OS_LOG_DEFAULT, "%{public}s (pid: %d) | EXEC: New image: %{public}s",
                msg->process->executable->path.data,
                audit_token_to_pid(msg->process->audit_token),
                msg->event.exec.target->executable->path.data);
            break;

        case ES_EVENT_TYPE_NOTIFY_FORK:
            os_log(OS_LOG_DEFAULT, "%{public}s (pid: %d) | FORK: Child pid: %d",
                msg->process->executable->path.data,
                audit_token_to_pid(msg->process->audit_token),
                audit_token_to_pid(msg->event.fork.child->audit_token));
            break;

        case ES_EVENT_TYPE_NOTIFY_EXIT:
            os_log(OS_LOG_DEFAULT, "%{public}s (pid: %d) | EXIT: status: %d",
                msg->process->executable->path.data,
                audit_token_to_pid(msg->process->audit_token),
                msg->event.exit.stat);
            break;

        case   ES_EVENT_TYPE_NOTIFY_OPEN:
            os_log(OS_LOG_DEFAULT, "Open event");
            break;
        case ES_EVENT_TYPE_NOTIFY_CLOSE:
            os_log(OS_LOG_DEFAULT, "Close event");

            break;
            
        default:
            os_log_error(OS_LOG_DEFAULT, "Unexpected event type encountered: %d\n", msg->event_type);
            break;
    }
}

void mutePath(es_client_t *client) {
    os_log(OS_LOG_DEFAULT,"Adding muted files list");
    
    NSArray<NSString *> *paths = @[
        @"/Applications/",
        @"/bin/",
        @"/cores/",
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
    
    // now mute under AnoopVaidya
    // it has to be recursively to end of the node(folder), and skip to the up-root
    
//    NSString *path = [NSString stringWithFormat:@"/Users/%@", @"anoopvaidya"];
//    NSMutableArray *mutedFolders = [[NSMutableArray alloc] init];
//
//    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
//                                                                        error:NULL];
//    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSString *folderName = (NSString *)obj;
//        NSString *fullFolderPath = [path stringByAppendingPathComponent:folderName];
//
//        // if these path are from the observed list - don't add
////        if (![fullFolderPath isEqualToString:[NSString stringWithFormat:@"%@", @"/Users/anoopvaidya/Documents"]]) {
//            [mutedFolders addObject:fullFolderPath];
////            os_log(OS_LOG_DEFAULT, "Mute adding: %@", fullFolderPath);
////        }
//    }];
//
//    NSLog(@"> %@", folders);
    // test code
    // remove this path, as I am observing
//    NSString *myFolder = [NSString stringWithFormat:@"%@", @"/Users/anoopvaidya/Documents"];
//    [folders removeObject:myFolder];
    
//    os_log(OS_LOG_DEFAULT, "Muted: %@", folders);
    
//    for (NSString *f in mutedFolders) {
//        es_mute_path_prefix(client, [f UTF8String]);
//    }
    os_log(OS_LOG_DEFAULT, "Muted: done");
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
    
//    es_event_type_t events[] = {
//        ES_EVENT_TYPE_NOTIFY_CREATE, //create file
//        ES_EVENT_TYPE_NOTIFY_OPEN, // open file
//        ES_EVENT_TYPE_NOTIFY_RENAME, // rename file
//        ES_EVENT_TYPE_NOTIFY_CLOSE, // close file
//        ES_EVENT_TYPE_NOTIFY_WRITE, // write to file
//        ES_EVENT_TYPE_NOTIFY_UNLINK, // delete
//        ES_EVENT_TYPE_NOTIFY_EXIT
//    };
    
    es_event_type_t events[] = { ES_EVENT_TYPE_NOTIFY_EXEC, ES_EVENT_TYPE_NOTIFY_FORK, ES_EVENT_TYPE_NOTIFY_EXIT };

    if (es_subscribe(client, events, sizeof(events) / sizeof(events[0])) != ES_RETURN_SUCCESS) {
        os_log(OS_LOG_DEFAULT, "Failed to subscribe to events");
        es_delete_client(client);
        return 1;
    }

    dispatch_main();
}
