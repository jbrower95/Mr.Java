//
//  ApplicationDelegate.h
//  Mr.Java
//
//  Created by Justin Brower on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"
/*
 Application listens on port 49200
 */

@interface ApplicationDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSDocumentController *docController;
}
@end
