//
//  NSMView.m
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMView.h"

@implementation NSMView
@synthesize delegate;

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    if ( delegate )
    {
        [delegate performDragOperation:sender];
        
    }
    printf("perform called!\n");
    
    return YES;
    
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
       if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}

@end
