//
//  DocumentController.m
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DocumentController.h"

@implementation DocumentController

- (void)newDocument:(id)sender
{
    // this will allow us to override the method for displaying a new document!!
    
    controller = [[NewDocumentController alloc] init];
    [controller showWindow:self];
    [controller setRef:self];
    [controller.window makeKeyAndOrderFront:self];
}

- (void)loadDocumentWithFilename:(NSString *)filename
{
    NSDocument *doc = [[Document alloc] init];
    filename = [NSString stringWithFormat:@"file:/%@",filename];
    printf("filename: %s\n",[filename UTF8String]);
    
    [doc readFromURL:[NSURL URLWithString:filename] ofType:@"mrj" error:nil];
    [doc makeWindowControllers];
    [doc showWindows];
    [controller.window close];
    [controller release];
    
}

@end
