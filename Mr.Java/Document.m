//
//  Document.m
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Document.h"

@implementation Document
@synthesize projectname;
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
    
    if ( fileLoader )
    {
        documentName = [[fileLoader propertyForKey:@"PROJECT_NAME"] retain];
        mainClass = [[fileLoader propertyForKey:@"MAIN_CLASS"] retain];
        [projectname setStringValue:[fileLoader propertyForKey:@"PROJECT_NAME"]];
        
        [aController.window setTitle:documentName];
        
    }
    [checkMark setHidden:YES];
    [crossMark setHidden:YES];
    [mainView registerForDraggedTypes:[NSArray arrayWithObjects:NSFileContentsPboardType,NSURLPboardType,nil]];
    
        
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







+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
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
    NSRange range = NSMakeRange([classP length]-1,1);
    [classP replaceCharactersInRange:range withString:@""];
    
    [arguments addObject:classP];
    
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

    
    [arguments addObject:[fileLoader propertyForKey:@"MAIN_CLASS"]];
    
    
  //  for ( NSString *a in arguments )
    //{
      //  NSLog(@"args: %@",a);
        
   // }
    [task setArguments:arguments];
    
    [task launch];
    
    //
    
    
    
    
    
    
    
    
}

- (IBAction)buildAndRun:(id)sender
{
    buildAndRunOn = YES;
    [self build:self];
 
    
    
    
    
    
    
    
    
}













@end
