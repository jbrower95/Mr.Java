//
//  NewDocumentController.h
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NewDocumentController : NSWindowController
{
    
    IBOutlet NSTextField *projectName;
    
    IBOutlet NSTextField *mainClass;
    
    IBOutlet NSTextField *mainDir;
    
    id ref;
    
}
@property (nonatomic, retain) id ref;
- (IBAction)searchDir:(id)sender;

- (IBAction)create:(id)sender;

@end
