//
//  DocumentController.m
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DocumentController.h"

@implementation DocumentController

@synthesize message,services,server,isConnectedToService;

- (void)newDocument:(id)sender
{
    // this will allow us to override the method for displaying a new document!!
    
    controller = [[NewDocumentController alloc] init];
    [controller showWindow:self];
    [controller setRef:self];
    [controller.window makeKeyAndOrderFront:self];
}

- (void)startUp
{
    printf("startup called\n");
	connectedRow = -1;
	services = [[NSMutableArray alloc] init];
	
	NSString *type = @"MrJProtocol";
    
	server = [[Server alloc] initWithProtocol:type];
    server.delegate = self;
    
    NSError *error = nil;
    if(![server start:&error]) {
        NSLog(@"error = %@", error);
    }	
    
    
}


- (void)serverRemoteConnectionComplete:(Server *)server 
{
    NSLog(@"Connected to service");
	
	self.isConnectedToService = YES;
    
	connectedRow = selectedRow;
	//[tableView reloadData];
}

- (void)serverStopped:(Server *)server 
{
    NSLog(@"Disconnected from service");
    
	self.isConnectedToService = NO;
    
	connectedRow = -1;
	//[tableView reloadData];
}

- (void)server:(Server *)server didNotStart:(NSDictionary *)errorDict 
{
    NSLog(@"Server did not start %@", errorDict);
}

- (void)server:(Server *)server didAcceptData:(NSData *)data 
{
    message = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
  //  NSLog(@"Server did accept data %@", message);
   if ( message != nil && message.length > 0 )
   {
       
       if ( [message isEqualToString:@"getProjs"] )
       {
           printf("Responding to \"getProjs\" request!\n\n\n");
           NSMutableString *response = [NSMutableString string];
           [response appendFormat:@"mrj100\n"];
           [response appendFormat:@"__PROJLIST__\n"];
           // respond with the mrj100 format:
           
           // we'll reply with project names
           
           NSArray *d = [self documents];
           for ( NSDocument *doc in d )
           {
               [response appendFormat:@"%@\n",[doc displayName]];
               
           }
           
           
           // serve up some content back, the server wants to know the projects
           NSData *back = [response dataUsingEncoding:NSUTF8StringEncoding];
           [server sendData:back error:nil];
           return;
           
       }
       if ( [message hasPrefix:@"copyProj"] )
       {
           // we're gonna copy the project
           
           
       }
       
       
   }
}

- (void)server:(Server *)server lostConnection:(NSDictionary *)errorDict 
{
	NSLog(@"Lost connection");
	
	self.isConnectedToService = NO;
	connectedRow = -1;
	//[tableView reloadData];
}

- (void)serviceAdded:(NSNetService *)service moreComing:(BOOL)more 
{
	NSLog(@"Added a service: %@", [service name]);
	
    [self.services addObject:service];
    if(!more) {
   //     [tableView reloadData];
    }
}

- (void)serviceRemoved:(NSNetService *)service moreComing:(BOOL)more 
{
	NSLog(@"Removed a service: %@", [service name]);
	
    [self.services removeObject:service];
    if(!more) {
   //     [tableView reloadData];
    }
}


- (void)loadDocumentWithFilename:(NSURL *)filename
{
    NSDocument *doc = [[Document alloc] init];
     
    filename = [filename URLByAppendingPathExtension:@"mrj"];
    [doc readFromURL:filename ofType:@"mrj" error:nil];
    [doc makeWindowControllers];
    [doc showWindows];
    [controller.window close];
    [controller release];
    [self addDocument:doc];
    
}

@end
