//
//  Created by Mikkel Gravgaard on 12/19/2014.
//  Copyright (c) 2014 Mikkel Gravgaard. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BTFLeakDetect : NSObject

+ (void)enableWithLogging;

+ (void)enableWithException;

@end