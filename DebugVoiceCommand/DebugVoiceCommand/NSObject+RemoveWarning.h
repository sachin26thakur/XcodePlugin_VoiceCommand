//
//  NSObject+RemoveWarning.h
//  DebugVoiceCommand
//
//  Created by Sachin on 14/10/15.
//  Copyright © 2015 Sachin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RemoveWarning)

- (void)_didStart;
- (void)_willExpire;
- (id)supportsDebugSession;
- (id)currentDebugSession;
- (void)requestStepOverLine;
- (void)requestStepOut;
- (void)requestPause;
- (void)requestStepIn;
- (void)requestContinue;

@end
