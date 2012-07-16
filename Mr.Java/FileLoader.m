//
//  FileLoader.m
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "FileLoader.h"

@implementation FileLoader

- (id)init
{
    self = [super init];
    done = NO;
    return self;
}

- (BOOL)loadFileFromData:(NSData *)data
{
    loadedKeys = [[NSMutableDictionary alloc] init];
    // initialize keys arrary
    
    
    // convert data to a UTF8 String
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    // seperate str by newlines
    NSArray *components = [str componentsSeparatedByString:@"\n"];
    
    // weed out comments
    NSMutableArray *goodRows = [NSMutableArray array];
    for ( NSString *s in components )
    {
        if ( ![s hasPrefix:COMMENT_SYMBOL] )
        {
            // copy over the line, it's not a comment.
            [goodRows addObject:s];
        }
    }
    
    
    //skeleton of the file format:
    
    
    
    /*
    
    mrj100
    PROJECT_NAME
    mainclass
    directory
 
    

     */
    
    // now, our quality checks:

if ( ![[goodRows objectAtIndex:0] isEqualTo:@"mrj100"] )
{
    
    // this file's invalid
    printf("invalid file!!\n");
    return NO;
    
    
}



// let's start loading.

    [loadedKeys setObject:[goodRows objectAtIndex:1] forKey:@"PROJECT_NAME"];
    [loadedKeys setObject:[goodRows objectAtIndex:2] forKey:@"MAIN_CLASS"];
    [loadedKeys setObject:[goodRows objectAtIndex:3] forKey:@"MAIN_DIR"];
    
    BOOL dir;
    
    BOOL dummy = [[NSFileManager defaultManager] fileExistsAtPath:[loadedKeys objectForKey:@"MAIN_DIR"] isDirectory:&dir];
    
    printf("dummy = %d, dir = %d\n", (dummy ? 0 : 1), (dir ? 0 : 1));
    
    if ( dummy == NO && dir == YES )
    {
        
        // well this is awkward. the specified "directory" is a file. RETURN NO
        return NO;
    }
    
    if ( dummy == NO && dir == NO )
    {
        // nothing exists.. lets create it
        NSError *e = nil;
        
      
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[loadedKeys objectForKey:@"MAIN_DIR"] withIntermediateDirectories:YES attributes:nil error:&e];
        if ( e == nil )
        {
        printf("creating working directory... %s\n",[[loadedKeys objectForKey:@"MAIN_DIR"] UTF8String]);   
        }
        else {
            printf("Error creating directory: %s\n",[[e localizedDescription] UTF8String]);
        }
    }
    
    // now we have a working directory! two more to go.
    
    /*
     
     The folder structures are as follows:
     
     
     MainFolder/SRC
     MainFolder/LIB
     MainFolder/CLS
     
     
     SRC compiles over to CLS
     
     CLS is executed with CLS, and LIB as the classpath
     
     
     */
    
    
    dir = NO;
    dummy = NO;
    
    
    // let's try it again for src
    
    NSString *temp = [[NSString alloc] initWithString:[loadedKeys objectForKey:@"MAIN_DIR"]];
    // copy over the main dir
    
    
    temp = [temp stringByAppendingPathComponent:@"SRC"];
    
    
    dummy = [[NSFileManager defaultManager] fileExistsAtPath:temp isDirectory:&dir];
    
    
    if ( dummy == NO && dir == NO )
    {
        // nothing exists.. lets create it
        NSError *e = nil;
        
        
        
        [[NSFileManager defaultManager] createDirectoryAtPath:temp withIntermediateDirectories:YES attributes:nil error:&e];
        
        if ( e == nil )
        {
            printf("creating working SRC directory... %s\n",[temp UTF8String]);   
        }
        else {
            printf("Error creating SRC directory: %s\n",[[e localizedDescription] UTF8String]);
        }
    }
    
    
    // now, we create our LIB folder..
    
    dummy = NO;
    dir = NO;
    temp = [temp stringByDeletingLastPathComponent];
    temp = [temp stringByAppendingPathComponent:@"LIB"];
    // copy over the main dir
    
    dummy = [[NSFileManager defaultManager] fileExistsAtPath:temp isDirectory:&dir];
    
    
    if ( dummy == NO && dir == NO )
    {
        // nothing exists.. lets create it
        NSError *e = nil;
        
        
        
        [[NSFileManager defaultManager] createDirectoryAtPath:temp withIntermediateDirectories:YES attributes:nil error:&e];
        
        if ( e == nil )
        {
            printf("creating working LIB directory... %s\n",[temp UTF8String]);   
        }
        else {
            printf("Error creating LIB directory: %s\n",[[e localizedDescription] UTF8String]);
        }
    }
    
    
    // and now finally, our CLS folder
    
    dummy = NO;
    dir = NO;
    temp = [temp stringByDeletingLastPathComponent];
    temp = [temp stringByAppendingPathComponent:@"CLS"];
    // copy over the main dir
    
    dummy = [[NSFileManager defaultManager] fileExistsAtPath:temp isDirectory:&dir];
    
    
    if ( dummy == NO && dir == NO )
    {
        // nothing exists.. lets create it
        NSError *e = nil;
        
        
        
        [[NSFileManager defaultManager] createDirectoryAtPath:temp withIntermediateDirectories:YES attributes:nil error:&e];
        
        if ( e == nil )
        {
            printf("creating working CLS directory... %s\n",[temp UTF8String]);   
        }
        else {
            printf("Error creating CLS directory: %s\n",[[e localizedDescription] UTF8String]);
        }
    }

    
    
    
    // and now, we're all set up with our folders!
    
    done = YES;
    
    
    return YES;
    
    
    
    
    
    
    
}
// loads a file from a chunk of NSData

- (id)propertyForKey:(NSString *)key
{
    if ( loadedKeys )
    {
        return ([loadedKeys objectForKey:key] ? [loadedKeys objectForKey:key] : @"");
        
    }
    else {
        return @"";
    }
    
    
}
// returns a direct link from the "loadedKeys" array...


- (BOOL)hasLoadedFile
{
    
    return done;
}




@end
