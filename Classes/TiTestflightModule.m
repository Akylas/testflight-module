/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiTestflightModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TestFlight.h"
#import "TestFlight+AsyncLogging.h"
#import "TiApp.h"


#define TF_PREFIX @"testflight."
extern NSString * const TI_APPLICATION_DEPLOYTYPE;
static BOOL asyncLog = false;
static BOOL testFilghtOn = false;
@implementation TiApp (TFLog)

+(void)TiNSLog:(NSString*) message
{
#pragma push
#undef NSLog
    if (testFilghtOn == false || [TI_APPLICATION_DEPLOYTYPE isEqualToString:@"development"]) {
        NSLog(@"%@",message);
    }
    else {
        if (asyncLog) {
            TFLog_async(@"[TFA] %@",message);
        }
        else {
            TFLog(@"[TF] %@",message);
        }
    }
#pragma pop
}
@end

@implementation TiTestflightModule

static NSDictionary* mapping = nil;
+(NSDictionary*)mapping
{
    if (mapping == nil) {
        mapping = @{
                    @"disableInAppUpdates":TFOptionDisableInAppUpdates,
                    @"flushSecondsInterval":TFOptionFlushSecondsInterval,
                    @"logOnCheckpoint":TFOptionLogOnCheckpoint,
                    @"lLogToConsole":TFOptionLogToConsole,
                    @"logToSTDERR":TFOptionLogToSTDERR,
                    @"reinstallCrashHandlers":TFOptionReinstallCrashHandlers,
                    @"reportCrashes":TFOptionReportCrashes,
                    @"sendLogOnlyOnCrash":TFOptionSendLogOnlyOnCrash,
                    @"sessionKeepAliveTimeout":TFOptionSessionKeepAliveTimeout
        };
    }
    return mapping;
}

MAKE_SYSTEM_PROP(OPTION_DISABLE_INAPP_UPDATES,@"disableInAppUpdates"); // Defaults to @NO. Setting to @YES, disables the in app update screen shown in BETA apps when there is a new version available on TestFlight.
MAKE_SYSTEM_PROP(OPTION_FLUSH_SECOND_INTERVAL,@"flushSecondsInterval"); // Defaults to @60. Set to a number. @0 turns off the flush timer. 30 seconds is the minimum flush interval.
MAKE_SYSTEM_PROP(OPTION_LONG_ON_CHECKPOINT,@"logOnCheckpoint"); // Defaults to @YES. Because logging is synchronous, if you have a high preformance app, you might want to turn this off.
MAKE_SYSTEM_PROP(OPTION_LOG_TO_CONSOLE,@"lLogToConsole"); // Defaults to @YES. Prints remote logs to Apple System Log.
MAKE_SYSTEM_PROP(OPTION_LOG_TO_SDTERR,@"logToSTDERR"); // Defaults to @YES. Sends remote logs to STDERR when debugger is attached.
MAKE_SYSTEM_PROP(OPTION_REINSTALL_CRASH_HANDLERS,@"reinstallCrashHandlers"); // If set to @YES: Reinstalls crash handlers, to be used if a third party library installs crash handlers overtop of the TestFlight Crash Handlers.
MAKE_SYSTEM_PROP(OPTION_REPORT_CRASHES,@"reportCrashes"); // Defaults to @YES. If set to @NO, crash handlers are never installed. Must be set **before** calling `takeOff:`.
MAKE_SYSTEM_PROP(OPTION_SEND_ONLY_ON_CRASH,@"sendLogOnlyOnCrash"); // Defaults to @NO. Setting to @YES stops remote logs from being sent when sessions end. They would only be sent in the event of a crash.
MAKE_SYSTEM_PROP(OPTION_SESSION_KEEP_ALIVE_TIMEOUT,@"sessionKeepAliveTimeout"); // Defaults to @30. This is the amount of time a user can leave the app for and still continue the same session when they come back. If they are away from the app for longer, a new session is created when they come back. Must be a number. Change to @0 to turn off.
MAKE_SYSTEM_PROP(OPTION_ASYNC_LOG,@"asyncLog"); // Defaults to @30. This is the amount of time a user can leave the app for and still continue the same session when they come back. If they are away from the app for longer, a new session is created when they come back. Must be a number. Change to @0 to turn off.

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"397c89fb-9d51-4c88-becd-9710a1bc7e97";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.testflight";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
    NSMutableDictionary* optionsToSet = [NSMutableDictionary dictionary];
    NSDictionary* tiappProperties = [TiApp tiAppProperties];
    [[TiTestflightModule mapping] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value = [tiappProperties objectForKey:[NSString stringWithFormat:@"%@%@", TF_PREFIX, key]];
        if (value) {
            [optionsToSet setObject:value forKey:obj];
        }
    }];
    [TestFlight setOptions:optionsToSet];
    testFilghtOn = YES;
    [self replaceValue:@(testFilghtOn) forKey:@"enabled" notification:NO];
    NSString* token = [tiappProperties objectForKey:@"testflight.token"];
    if ([tiappProperties objectForKey:@"testflight.asyncLog"]) {
        DebugLog(@"[INFO] TestFlight asyncLogging");
        asyncLog = [[tiappProperties objectForKey:@"testflight.asyncLog"] boolValue];
    }
    [self replaceValue:@(asyncLog) forKey:@"asyncLog" notification:NO];
    
    if (token) {
        DebugLog(@"[INFO] TestFlight takeOff %@", token);
        [TestFlight takeOff:token];
    }
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma Public APIs

-(id)getObjectProperty:(NSString*)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

-(BOOL)getBoolProperty:(NSString*)key defaultValue:(BOOL)defaultValue
{
    id object = [self getObjectProperty:key];
    if (object) {
        return [object boolValue];
    }
    return defaultValue;
}

-(NSString*)getStringProperty:(NSString*)key defaultValue:(NSString*)defaultValue
{
    id object = [self getObjectProperty:key];
    if (object) {
        return [object stringValue];
    }
    return defaultValue;
}

-(void)takeOff:(id)args
{
    ENSURE_UI_THREAD(takeOff, args);
    ENSURE_SINGLE_ARG_OR_NIL(args,NSString);
    
    [TestFlight takeOff:args];
    DebugLog(@"[INFO] TestFlight takeOff %@", args);
}

-(void)passCheckpoint:(id)args
{    
    ENSURE_UI_THREAD_1_ARG(args);

    NSString *value = [TiUtils stringValue:[args objectAtIndex:0]];
    [TestFlight passCheckpoint:value];
}

-(void)submitFeedback:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    NSString *value = [TiUtils stringValue:[args objectAtIndex:0]];
    [TestFlight submitFeedback:value];
}

-(void)addCustomEnvironmentInformation:(id)args
{
    ENSURE_ARG_COUNT(args, 2)

    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    NSString *value = [TiUtils stringValue:[args objectAtIndex:1]];
    [TestFlight addCustomEnvironmentInformation: value forKey:key];
}

-(void)log:(id)args
{
    ENSURE_UI_THREAD(log, args);
    NSString* key = nil;
    NSString *value = nil;
    ENSURE_ARG_OR_NIL_AT_INDEX(key, args, 0, NSString);
    ENSURE_ARG_OR_NIL_AT_INDEX(value, args, 1, NSString);

    if (key) {
        if (value) {
            TFLog(@"[%@] %@",key,value);
        }
        else {
            TFLog(@"%@",key);
        }
    }
}



-(id)sdkVersion:(id)args
{
    return TESTFLIGHT_SDK_VERSION;
}

- (void)setOptions:(id)args
{
    ENSURE_UI_THREAD(setOptions, args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    NSMutableDictionary* optionsToSet = [NSMutableDictionary dictionary];
    [args enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value = [[TiTestflightModule mapping] objectForKey:key];
        if (value) {
            [optionsToSet setObject:obj forKey:value];
        }
    }];
    [TestFlight setOptions:optionsToSet];
}

-(void)setAsyncLog:(id)val
{
    asyncLog  = [TiUtils boolValue:val def:asyncLog];
    [self replaceValue:@(asyncLog) forKey:@"asyncLog" notification:NO];
}

-(void)setEnabled:(id)val
{
    testFilghtOn  = [TiUtils boolValue:val def:testFilghtOn];
    [self replaceValue:@(testFilghtOn) forKey:@"enabled" notification:NO];
}


@end
