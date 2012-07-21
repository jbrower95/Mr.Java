//
//  DocumentController.h
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NewDocumentController.h"
#import "Document.h"
#import "Server.h"
@interface DocumentController : NSDocumentController <ServerDelegate>
{
    NewDocumentController *controller;
    
    Server *server;
	NSMutableArray *services;
	NSString *textToSend, *message;
	NSInteger selectedRow, connectedRow;
	BOOL isConnectedToService;
    
    
}

@property(nonatomic, retain) Server *server;
@property(nonatomic, retain) NSMutableArray *services;
@property(readwrite, copy) NSString *message;
@property(readwrite, nonatomic) BOOL isConnectedToService;

- (void)startUp;
@end
