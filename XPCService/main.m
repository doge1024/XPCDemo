//
//  main.m
//  XPCService
//
//  Created by TanHao on 12-12-13.
//  Copyright (c) 2012年 tanhao.me. All rights reserved.
//

#include <xpc/xpc.h>
#include <Foundation/Foundation.h>
//#import "NSDictionary+XPCParse.h"

static void XPCService_peer_event_handler(xpc_connection_t peer, xpc_object_t event) 
{
	xpc_type_t type = xpc_get_type(event);
	if (type == XPC_TYPE_ERROR)
    {
		if (event == XPC_ERROR_CONNECTION_INVALID)
        {
            //连接无效
		}
        else if (event == XPC_ERROR_TERMINATION_IMMINENT)
        {
			//即将终止
		}
	} else
    {
        //处理业务
        double value1 = xpc_dictionary_get_double(event, "value1");
        double value2 = xpc_dictionary_get_double(event, "value2");
        
        xpc_object_t dictionary = xpc_dictionary_create(NULL, NULL, 0);
        xpc_dictionary_set_double(dictionary, "result", value1+value2);
        
        xpc_connection_send_message(peer, dictionary);
	}
}

static void XPCService_event_handler(xpc_connection_t peer) 
{
	xpc_connection_set_event_handler(peer, ^(xpc_object_t event) {
		XPCService_peer_event_handler(peer, event);
	});
	xpc_connection_resume(peer);
}

int main(int argc, const char *argv[])
{
	xpc_main(XPCService_event_handler);
	return 0;
}
