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
    [NSApp activateIgnoringOtherApps:YES];
}


- (IBAction)source:(id)sender
{
    
    // it's a source file. Copy it to our SRC directory.

    
    // as a precondition, MAIN_DIR/SRC must exist.
    NSError *e = nil;
    NSSound *copy = [NSSound soundNamed:@"copy"];
    
    NSString *path = [[NSURL URLWithString:f] path];
    
    [[NSFileManager defaultManager] copyItemAtPath:path toPath:[[mDir stringByAppendingPathComponent:@"SRC"] stringByAppendingPathComponent:[f lastPathComponent]] error:&e];
    
    if ( e )
    {
        printf("Could not copy file to SRC :( %s\n",[[e localizedDescription] UTF8String]);
        
        if ( [[e localizedDescription] rangeOfString:@"name already exists"].location != NSNotFound)
        {
            
            // the item already exists
            
            NSAlert *alert = [[[NSAlert alloc] init] autorelease];
            [alert setMessageText:[NSString stringWithFormat:@"The specified file already exists! Would you like to overwrite it? (this cannot be undone)"]];
            [alert addButtonWithTitle:@"Okay"];
            [alert addButtonWithTitle:@"Cancel"];
            addCode = 0;
            [alert beginSheetModalForWindow:self.window
                              modalDelegate:self
                             didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                                contextInfo:nil];
            
        }
        
        return;
    }
    [copy play];
    
    [self close];
    
}


- (void) alertDidEnd:(NSAlert *)a returnCode:(NSInteger)rc contextInfo:(void *)ci {
    switch(rc) {
        case NSAlertFirstButtonReturn:
        {
       // we're going to proceed with the copy
            
            
            NSString *path = [[NSURL URLWithString:f] path];
            NSError *e = nil;
            NSError *er = nil;
           if ( addCode == 0 )
           {
            
           // src file
            [[NSFileManager defaultManager] removeItemAtPath:[[mDir stringByAppendingPathComponent:@"SRC"] stringByAppendingPathComponent:[f lastPathComponent]] error:&er];
            
              [[NSFileManager defaultManager] copyItemAtPath:path toPath:[[mDir stringByAppendingPathComponent:@"SRC"] stringByAppendingPathComponent:[f lastPathComponent]] error:&e];
           }
            if ( addCode == 1 )
            {
                // library
                [[NSFileManager defaultManager] removeItemAtPath:[[mDir stringByAppendingPathComponent:@"LIB"] stringByAppendingPathComponent:[f lastPathComponent]] error:&er];
                
                [[NSFileManager defaultManager] copyItemAtPath:path toPath:[[mDir stringByAppendingPathComponent:@"LIB"] stringByAppendingPathComponent:[f lastPathComponent]] error:&e];
                
            }
            if ( addCode == 2 )
            {
                // proj resource
                [[NSFileManager defaultManager] removeItemAtPath:[mDir  stringByAppendingPathComponent:[f lastPathComponent]] error:&er];
                
                [[NSFileManager defaultManager] copyItemAtPath:path toPath:[mDir  stringByAppendingPathComponent:[f lastPathComponent]] error:&e];
                
                
            }
            
            if ( e == nil && er == nil )
            {
                // good to go.
                [[NSSound soundNamed:@"copy"] play];
                [self close];
            }
            else {
                // we failed.
                [[NSSound soundNamed:@"failure"] play];
                [self close];
            }
            
        }
    }
}



- (IBAction)library:(id)sender
{
    // it's a lib file. Copy it to our LIB directory.
    
    
    // as a precondition, MAIN_DIR/LIB must exist.
    NSError *e = nil;
    NSSound *copy = [NSSound soundNamed:@"copy"];
    
    NSString *path = [[NSURL URLWithString:f] path];
    
    [[NSFileManager defaultManager] copyItemAtPath:path toPath:[[mDir stringByAppendingPathComponent:@"LIB"] stringByAppendingPathComponent:[f lastPathComponent]] error:&e];
    
    if ( e )
    {
        printf("Could not copy file to LIB :( %s\n",[[e localizedDescription] UTF8String]);
        
        if ( [[e localizedDescription] rangeOfString:@"name already exists"].location != NSNotFound)
        {
            
            // the item already exists
            
            NSAlert *alert = [[[NSAlert alloc] init] autorelease];
            [alert setMessageText:[NSString stringWithFormat:@"The specified file already exists! Would you like to overwrite it? (this cannot be undone)"]];
            [alert addButtonWithTitle:@"Okay"];
            [alert addButtonWithTitle:@"Cancel"];
            addCode = 1;
            [alert beginSheetModalForWindow:self.window
                              modalDelegate:self
                             didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                                contextInfo:nil];
            
        }
        
        return;
    }
    [copy play];
    
    [self close];
    
    
    
}

- (IBAction)projectResource:(id)sender
{
    
    NSError *e = nil;
    NSSound *copy = [NSSound soundNamed:@"copy"];
    
    NSString *path = [[NSURL URLWithString:f] path];
    
    [[NSFileManager defaultManager] copyItemAtPath:path toPath:[mDir stringByAppendingPathComponent:[f lastPathComponent]] error:&e];
    
    if ( e )
    {
        printf("Could not copy file to MAINDIR :( %s\n",[[e localizedDescription] UTF8String]);
        
        if ( [[e localizedDescription] rangeOfString:@"name already exists"].location != NSNotFound)
        {
            
            // the item already exists
            
            NSAlert *alert = [[[NSAlert alloc] init] autorelease];
            [alert setMessageText:[NSString stringWithFormat:@"The specified file already exists! Would you like to overwrite it? (this cannot be undone)"]];
            [alert addButtonWithTitle:@"Okay"];
            [alert addButtonWithTitle:@"Cancel"];
            addCode = 2;
            [alert beginSheetModalForWindow:self.window
                              modalDelegate:self
                             didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                                contextInfo:nil];
            
        }
        
        return;
    }
    [copy play];
    
    [self close];
    
    
}




@end
