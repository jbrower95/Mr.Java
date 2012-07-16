//
//  FileLoader.h
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


// a class to ease the loading of files.


/************
 
 
 
 To change the comments format, simply change the define below
 
 We also ignore whitespace lines
 
 */

#define COMMENT_SYMBOL @"#"




#import <Foundation/Foundation.h>

@interface FileLoader : NSObject
{
    
    NSMutableDictionary *loadedKeys;
    
    
    BOOL done;
    
    
    
    
}



// interface
- (BOOL)hasLoadedFile;

- (BOOL)loadFileFromData:(NSData *)data;
// loads a file from a chunk of NSData

- (id)propertyForKey:(NSString *)key;
// returns a direct link from the "loadedKeys" array...

// Valid args are:

// PROJECT_NAME   NSString *
// MAIN_CLASS     NSString *
// MAIN_DIR      NSString *
// CLASS_PATH     NSArray &





@end
