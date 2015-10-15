//
//  NSObject_Extension.m
//  DebugVoiceCommand
//
//  Created by Sachin on 14/10/15.
//  Copyright © 2015 Sachin. All rights reserved.
//


#import "NSObject_Extension.h"
#import "DebugVoiceCommand.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[DebugVoiceCommand alloc] initWithBundle:plugin];
        });
    }
}







@end
