//
//  AddController.m
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddController.h"

@interface AddController ()

@end

@implementation AddController


- (id)initWithMainDir:(NSString *)_mainDir file:(NSString *)file
{
    self = [super initWithWindowNibName:@"AddToProject"];
    mDir = [[NSString alloc] initWithString:_mainDir];
    f = [[NSString alloc] initWithString:file];
    
    
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
  //  [self.window makeKeyAndOrderFront:self.window];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [projectName setStringValue:[f lastPathComponent]];
}


- (IBAction)source:(id)sender
{
    
    // it's a source file. Copy it to our SRC directory.
    
    if ( [f hasPrefix:@"file://localhost"] )
    {
        
        f = [f substringFromIndex:16];
        [f retain];
        
    }
    
    // as a precondition, MAIN_DIR/SRC must exist.
    NSError *e = nil;
    
    [[NSFileManager defaultManager] copyItemAtPath:f toPath:[[mDir stringByAppendingPathComponent:@"SRC"] stringByAppendingPathComponent:[f lastPathComponent]] error:&e];
    
    if ( e )
    {
        printf("Could not copy file to SRC :( %s\n",[[e localizedDescription] UTF8String]);
        return;
    }
    NSSound *copy = [NSSound soundNamed:@"copy"];
    [copy play];
    
    [self close];
    
}
- (IBAction)library:(id)sender
{
    NSError *e = nil;
    
    if ( [f hasPrefix:@"file://localhost"] )
    {
        
        f = [f substringFromIndex:16];
        [f retain];
        
    }
    
    [[NSFileManager defaultManager] copyItemAtPath:f toPath:[[mDir stringByAppendingPathComponent:@"LIB"] stringByAppendingPathComponent:[f lastPathComponent]] error:&e];
    
    if ( e )
    {
        printf("Could not copy file to LIB :( %s\n",[[e localizedDescription] UTF8String]);
        return;
    }
    NSSound *copy = [NSSound soundNamed:@"copy"];
    [copy play];
    
    [self close];
    
    
    
    
}




@end
