//
//  Document.h
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileLoader.h"
#import "NSMView.h"
#import "AddController.h"
@interface Document : NSDocument <NSComboBoxDataSource, NSComboBoxDelegate>
{
    NSString *documentName;
    NSString *documentDir;
    
    IBOutlet NSMView *mainView;
    
    IBOutlet NSTextField *projectname;
    
    FileLoader *fileLoader;
    
    NSString *mainClass;
    
    IBOutlet NSImageView *checkMark;
    IBOutlet NSImageView *crossMark;
    IBOutlet NSProgressIndicator *spinner;
    
    BOOL buildAndRunOn;
    
    IBOutlet NSComboBox *classesBox;
    
    NSMutableArray *classes;
    
    NSFileHandle *runHandle;
    
    NSFileHandle *stdoutFile;
}
@property (nonatomic, retain) FileLoader *fileLoader;
- (IBAction)help:(id)sender;
- (IBAction)build:(id)sender;

- (IBAction)run:(id)sender;

- (IBAction)buildAndRun:(id)sender;


@property (nonatomic, retain) IBOutlet NSTextField *projectname;

@end
