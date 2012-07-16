//
//  NSMView.h
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSMView : NSView
{
    IBOutlet id delegate;
    
}
@property (nonatomic, retain) id delegate;

@end
