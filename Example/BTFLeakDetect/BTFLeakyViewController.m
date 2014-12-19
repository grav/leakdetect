//
// Created by Mikkel Gravgaard on 19/12/14.
// Copyright (c) 2014 Mikkel Gravgaard. All rights reserved.
//

#import "BTFLeakyViewController.h"


@implementation BTFLeakyViewController {
    id _leakSelf;
}

- (void)leak {
    _leakSelf = self;
}

- (void)dealloc {
    NSLog(@"Dealloced view controller");
}


@end