//
//  DebugVoiceCommand.h
//  DebugVoiceCommand
//
//  Created by Sachin on 14/10/15.
//  Copyright © 2015 Sachin. All rights reserved.
//

#import <AppKit/AppKit.h>

@class DebugVoiceCommand;

static DebugVoiceCommand *sharedPlugin;

@interface DebugVoiceCommand : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end