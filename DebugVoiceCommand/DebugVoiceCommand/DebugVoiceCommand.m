//
//  DebugVoiceCommand.m
//  DebugVoiceCommand
//
//  Created by Sachin on 14/10/15.
//  Copyright © 2015 Sachin. All rights reserved.
//

#import "DebugVoiceCommand.h"
#import "Aspects.h"
#import "NSObject+RemoveWarning.h"




@interface DebugVoiceCommand()<NSSpeechRecognizerDelegate>

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic,strong) id <AspectInfo> session;
@property (nonatomic,strong) NSSpeechRecognizer *listen;
@end

@implementation DebugVoiceCommand

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [self performSelector:@selector(doRegisterSelectorMethodOfDebuggerSession) withObject:nil afterDelay:8.0];
    }
    return self;
}


- (void)doRegisterSelectorMethodOfDebuggerSession{
    
    
    [self log:@"doRegisterSelectorMethodOfDebuggerSession \n"];
    
    
    [objc_getClass("IDELaunchSession") aspect_hookSelector:@selector(_didStart) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        [self log:@"_didStart \n"];
        if ([aspectInfo.instance supportsDebugSession]) {
            [self performSelector:@selector(doStartVoiceCommand:) withObject:aspectInfo afterDelay:5.0];
        }
        
    } error:nil];

   
    [objc_getClass("IDELaunchSession") aspect_hookSelector:@selector(_willExpire) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        [self log:@"_willExpire \n"];
        if ([aspectInfo.instance supportsDebugSession]) {
            [self doStopVoiceCommand];
        }
    } error:nil];
    
    
    
    

    
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)log:(NSString*)msg{
    // get path to Documents/somefile.txt
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"logfile.txt"];
    // create if needed
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        fprintf(stderr,"Creating file at %s",[path UTF8String]);
        [[NSData data] writeToFile:path atomically:YES];
    }
    // append
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}



#pragma mark - 
#pragma mark - Voice Command methods



- (void)doStartVoiceCommand:(id <AspectInfo>) info{
    [self log:[NSString stringWithFormat:@"debug session do Test %@",[[info.instance currentDebugSession] class]]];
    self.session  = info;
    
    NSArray *myCommands = [NSArray arrayWithObjects:@"Step In", @"Step Over",
                           @"Step Out", @"Pause", @"Continue", @"play", nil];
    
    if (_listen) {
        [_listen startListening];
        return;
    }
    
    _listen = [[NSSpeechRecognizer alloc] init];
    [_listen setCommands:myCommands];
    [_listen setListensInForegroundOnly:NO];
    [_listen setBlocksOtherRecognizers:YES];
    [_listen setDelegate:self];
    [_listen startListening];
}



- (void)doStopVoiceCommand{
    if (_listen) {
    [_listen stopListening];
    }
}


- (void)speechRecognizer:(NSSpeechRecognizer *)sender didRecognizeCommand:(id)aCmd {
    [self log:(NSString*)aCmd];
    if ([(NSString *)aCmd isEqualToString:@"Step Over"]) {
        [[self.session.instance currentDebugSession] performSelector:@selector(requestStepOverLine)];
    }else if([(NSString *)aCmd isEqualToString:@"Step Out"]){
        [[self.session.instance currentDebugSession] performSelector:@selector(requestStepOut)];
    }else if([(NSString *)aCmd isEqualToString:@"Pause"]){
        [[self.session.instance currentDebugSession] performSelector:@selector(requestPause)];
    }else if([(NSString *)aCmd isEqualToString:@"Step In"]){
        [[self.session.instance currentDebugSession] performSelector:@selector(requestStepIn)];
    }else if([(NSString *)aCmd isEqualToString:@"Continue"]){
        [[self.session.instance currentDebugSession] performSelector:@selector(requestContinue)];
    }
}


@end
