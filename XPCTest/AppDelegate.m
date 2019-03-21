//
//  AppDelegate.m
//  XPCTest
//
//  Created by TanHao on 12-12-13.
//  Copyright (c) 2012年 tanhao.me. All rights reserved.
//

#import "AppDelegate.h"
//#import "NSDictionary+XPCParse.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    xpc_connection_t connection = xpc_connection_create_mach_service("com.moft.XPCService.XPCService",
                                                                 NULL,
                                                                 XPC_CONNECTION_MACH_SERVICE_PRIVILEGED);
    
    xpc_connection_set_event_handler(connection, ^(xpc_object_t object){
        
        double result = xpc_dictionary_get_double(object, "result");
        NSLog(@"%f",result);
        
    });
    xpc_connection_resume(connection);
    
    xpc_object_t dictionary = xpc_dictionary_create(NULL, NULL, 0);
    xpc_dictionary_set_double(dictionary, "value1", 1.0);
    xpc_dictionary_set_double(dictionary, "value2", 2.0);
    
    xpc_connection_send_message(connection, dictionary);
}

@end
