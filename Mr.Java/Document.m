//
//  Document.m
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Document.h"

@implementation Document
@synthesize projectname, fileLoader;
- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
    
    
    
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    documentName = [[NSString alloc] initWithString:@"Untitled"];
    [projectname setStringValue:documentName];
    classes = [[NSMutableArray alloc] init];
    if ( fileLoader )
    {
        documentName = [[fileLoader propertyForKey:@"PROJECT_NAME"] retain];
        mainClass = [[fileLoader propertyForKey:@"MAIN_CLASS"] retain];
        [projectname setStringValue:[fileLoader propertyForKey:@"PROJECT_NAME"]];
        
        
        
        [self senseClasses];
        
        [aController.window setTitle:documentName];
        
        
        [classesBox setStringValue:([[fileLoader propertyForKey:@"MAIN_CLASS"] isEqualToString:@"__NONE__"] ? @"" : [fileLoader propertyForKey:@"MAIN_CLASS"])];
        
        
    }
    [self senseClasses];
    [checkMark setHidden:YES];
    [crossMark setHidden:YES];
    [mainView registerForDraggedTypes:[NSArray arrayWithObjects:NSFileContentsPboardType,NSURLPboardType,nil]];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(senseClasses) userInfo:nil repeats:YES];
}


- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{

    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSURLPboardType] ) {
        NSURL *fileURL = [NSURL URLFromPasteboard:pboard];
        // Perform operation using the file’s URL
        
        printf("File dropped! : %s\n",[[fileURL absoluteString] UTF8String]);
        
        AddController *a = [[AddController alloc] initWithMainDir:[fileLoader propertyForKey:@"MAIN_DIR"] file:[fileURL absoluteString]];
        // [a.window makeKeyAndOrderFront:a.window];
        [a showWindow:self];
    }
    
    
    return YES;
    
    
    
}

- (void)senseClasses
{
    // all classes are found in /CLS
    
    [classes removeAllObjects];
    NSError *e = nil;
    
    NSFileManager *steve = [NSFileManager defaultManager];
    NSArray *contents = [steve contentsOfDirectoryAtPath:[[fileLoader propertyForKey:@"MAIN_DIR"] stringByAppendingPathComponent:@"CLS"] error:&e];
    
    
    if ( e )
    {
        // we had an uh oh
        NSAlert *a = [NSAlert alertWithMessageText:@"Error!" defaultButton:@"Okay" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Directory enumeration failed in CLS: Could not sense classes (%@)",[e localizedDescription]];
         [a runModal];
        return;
    }
    
    // otherwise, lets get to work
    
    for (NSString *entry in contents )
    {
        BOOL dir;
        if ( [steve fileExistsAtPath:[[[fileLoader propertyForKey:@"MAIN_DIR"] stringByAppendingPathComponent:@"CLS/"] stringByAppendingPathComponent:entry] isDirectory:&dir] && dir == NO )
        {
            
            
            // it's a valid file.. check for the .class suffix
            
            if ( [entry hasSuffix:@".class"] )
            {
                
                // now we're getting somewhere... we've found a class file. 
                
                NSString *chopped = [entry substringToIndex:[entry rangeOfString:@".class"].location];
                [classes addObject:chopped];
                
                
                
            }
            
            
            
            
            
        }
        
        
        
        
    }
    
    
[classesBox reloadData];
    
}

- (IBAction)help:(id)sender
{
    
    NSAlert *helpPopup = [NSAlert alertWithMessageText:@"Help" defaultButton:@"Okay" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"This is the class that will be executed when you hit either \"run\" or \"build and run\". As such, it is necessary that you select a class before executing!"];
    [helpPopup runModal];
  
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{
    // this is all we care about
    printf("changing main class..\n");
    [fileLoader changeMainClass:(NSString *)[classes objectAtIndex:[classesBox indexOfSelectedItem]]];

    //[self save];
    
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    if ( control == classesBox )
    {
        NSString *text = [fieldEditor string];
        
        [fileLoader changeMainClass:text];
    }
    
    return YES;
    
}



// combo box code

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
    
    
    
    return [classes objectAtIndex:index] ? [classes objectAtIndex:index] : @"";
    
    
    
    
    
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    
    return [classes count] ? [classes count] : 0;
    
    
    
}




+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    return [fileLoader generateData];
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return 
    
    fileLoader = [[FileLoader alloc] init];
    [fileLoader loadFileFromData:data];
    
    
   // [projectname setStringValue:documentName];
    return YES;
}








- (IBAction)build:(id)sender
{
    
    // the building action
    [spinner startAnimation:spinner];
    
    
    if ( [fileLoader hasLoadedFile] )
    {
    [NSThread detachNewThreadSelector:@selector(buildAction) toTarget:self withObject:nil];
    }
    
    
}

- (void)buildAction
{
    
    
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/javac"];
    [task setCurrentDirectoryPath:[fileLoader propertyForKey:@"MAIN_DIR"]];
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    [task setStandardError:pipe];
    
    // first, lets set our source path...
    
    
    
    // now lets set our destination to "CLS"
    
    [arguments addObject:@"-d"];
    [arguments addObject:@"CLS"];
    
    
    [arguments addObject:@"-cp"];
    
    NSMutableString *classP = [[NSMutableString alloc] init];
    
    NSArray *list =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[fileLoader propertyForKey:@"MAIN_DIR"] stringByAppendingPathComponent:@"LIB"] error:nil];
    NSArray *srcFiles = list;
    
    for ( int i = 0; i < [srcFiles count]; i++)
    {
        [classP appendString:[NSString stringWithFormat:@"%@/LIB/%@",[fileLoader propertyForKey:@"MAIN_DIR"],[srcFiles objectAtIndex:i]]];
        [classP appendString:@":"];
        
    }
    @try{
    NSRange range = NSMakeRange([classP length]-1,1);
    [classP replaceCharactersInRange:range withString:@""];
    
    [arguments addObject:classP];
    }
    @catch ( NSException *e )
    {
        // it dun failed
        // do something else maybe?
        
    }
    // compile the classpath from the LIB folder
    
    
    
    
    // enumerate all of the files in /SRC/
    
    list =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[fileLoader propertyForKey:@"MAIN_DIR"] stringByAppendingPathComponent:@"SRC"] error:nil];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"self ENDSWITH '.java'"];
    srcFiles = [list filteredArrayUsingPredicate:pred];
    
    for ( int i = 0; i < [srcFiles count]; i++)
    {
        [arguments addObject:[NSString stringWithFormat:@"%@/SRC/%@",[fileLoader propertyForKey:@"MAIN_DIR"],[srcFiles objectAtIndex:i]]];
        
        
    }
    
    
    
    [task setArguments:arguments];
    
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data
                                   encoding: NSUTF8StringEncoding];
     
    if ( [string rangeOfString:@"error"].location != NSNotFound )
    {
        
    
        [self performSelectorOnMainThread:@selector(failed) withObject:string waitUntilDone:NO];
        
        
    }
    else {
        [self performSelectorOnMainThread:@selector(successBuild) withObject:nil waitUntilDone:NO];
        
    }
    
    
}

- (void)failed:(NSString *)reason
{
    // we have an error :(
    NSAlert *a = [NSAlert alertWithMessageText:@"Compiler Error!" defaultButton:@"Okay" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:reason];
    [a runModal];
    [checkMark setHidden:YES];
    [crossMark setHidden:NO];
    
    NSSound *sound = [NSSound soundNamed:@"failure"];
    [sound play];
    
    [spinner stopAnimation:spinner];
    
}

- (void)successBuild
{
    
    NSSound *sound = [NSSound soundNamed:@"success"];
    [sound play];
    
    [crossMark setHidden:YES];
    [checkMark setHidden:NO];
    
    [spinner stopAnimation:spinner];
    
    if ( buildAndRunOn )
    {
        [self run:self];
    }
    
    
}


- (IBAction)run:(id)sender
{
    buildAndRunOn = NO;
    NSTask *task = [[NSTask alloc] init];
    
    NSPipe *_STDOUT = [NSPipe pipe];
    
    [task setStandardError:_STDOUT];
    [task setStandardOutput:_STDOUT];
    
    runHandle = [_STDOUT fileHandleForReading];
    [runHandle retain];
    [runHandle waitForDataInBackgroundAndNotify];
    
    [task setLaunchPath:@"/usr/bin/java"];
    [task setCurrentDirectoryPath:[fileLoader propertyForKey:@"MAIN_DIR"]];
    
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    
    // let's run this son of a bitch

    [arguments addObject:@"-cp"];
    
    NSMutableString *classP = [[NSMutableString alloc] init];
    
    [classP appendString:@"./CLS/:"];
    NSArray *list =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[fileLoader propertyForKey:@"MAIN_DIR"] stringByAppendingPathComponent:@"LIB"] error:nil];
    NSArray *srcFiles = list;
    
    
    for ( int i = 0; i < [srcFiles count]; i++)
    {
        if ( [[srcFiles objectAtIndex:i] rangeOfString:@".DS_Store"].location == NSNotFound )
        {
        [classP appendString:[NSString stringWithFormat:@"%@/LIB/%@",[fileLoader propertyForKey:@"MAIN_DIR"],[srcFiles objectAtIndex:i]]];
        [classP appendString:@":"];
        }
    }
    NSRange range = NSMakeRange([classP length]-1,1);
    [classP replaceCharactersInRange:range withString:@""];
    
    [arguments addObject:classP];

    printf("Executing class: %s\n",[[fileLoader propertyForKey:@"MAIN_CLASS"] UTF8String] );
    [arguments addObject:[fileLoader propertyForKey:@"MAIN_CLASS"]];
    
    
  //  for ( NSString *a in arguments )
    //{
      //  NSLog(@"args: %@",a);
        
   // }
    [task setArguments:arguments];
    
    [task launch];
  
}
- (void) dataAvailable: (NSNotification*)notification
{
	// read data directly from the fd
    printf("Data available!\n");
    NSData *newData = [runHandle availableData];
    
    [self appendDataToSTDOUT:newData];
    
	[runHandle waitForDataInBackgroundAndNotify];
}


- (void)appendDataToSTDOUT:(NSData *)d
{
    if ( !stdoutFile )
    {
        // check to see if stdout exists
        
        if ( ![[NSFileManager defaultManager] fileExistsAtPath:[[fileLoader propertyForKey:@"MAIN_DIR"] stringByAppendingPathComponent:@"stdout.txt"] isDirectory:nil])
        {
            [[NSFileManager defaultManager] createFileAtPath:[[fileLoader propertyForKey:@"MAIN_DIR"] stringByAppendingPathComponent:@"stdout.txt"] contents:nil attributes:nil];
        }
        
        stdoutFile = [NSFileHandle fileHandleForUpdatingAtPath:[[fileLoader propertyForKey:@"MAIN_DIR"] stringByAppendingPathComponent:@"stdout.txt"]];
        [stdoutFile seekToEndOfFile];
        [stdoutFile writeData:[@"-----------------\nCommencing launching of application...\n\n--------------------\n\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    }
    
    [stdoutFile seekToEndOfFile];
    [stdoutFile writeData:d];
    
    
    
    
    
    
}



- (NSString *)displayName
{
    return ([fileLoader propertyForKey:@"PROJECT_NAME"] ? [fileLoader propertyForKey:@"PROJECT_NAME"] : [super displayName]);
    
    
}

- (IBAction)buildAndRun:(id)sender
{
    buildAndRunOn = YES;
    [self build:self];
 
    
    
    
    
    
    
    
    
}













@end
