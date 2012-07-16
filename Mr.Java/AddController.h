//
//  AddController.h
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AddController : NSWindowController
{
    NSString *mDir;
    NSString *f;
    
    IBOutlet NSTextField *projectName;
    
}

- (IBAction)source:(id)sender;
- (IBAction)library:(id)sender;

- (id)initWithMainDir:(NSString *)mainDir file:(NSString *)file;
@end
