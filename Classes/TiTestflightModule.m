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
#import "TiApp.h"

@implementation TiTestflightModule

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
    NSDictionary* tiappProperties = [TiApp tiAppProperties];
    if ([tiappProperties objectForKey:@"testflight.sendLogOnlyOnCrash"]) {
        [TestFlight setOptions:[NSDictionary dictionaryWithObject:[tiappProperties objectForKey:@"testflight.sendLogOnlyOnCrash"] forKey:@"sendLogOnlyOnCrash"]];
    }
    NSString* token = [tiappProperties objectForKey:@"testflight.token"];
    
    if (token) {
        DebugLog(@"[INFO] TestFlight takeOff %@", token);
        [TestFlight takeOff:token];
    }
	DebugLog(@"[INFO] %@ loaded",self);
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
    
    DebugLog(@"[INFO] TestFlight takeOff %@", args);
    [TestFlight takeOff:args];
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
        //we have one
        if (value) {
            //we have 2
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

/*- (id)setOptions:(id)args
{
    ENSURE_UI_THREAD(setOptions, args);
    
    ENSURE_ARG_COUNT(args, 1);
    id options = [args objectAtIndex:0];
    ENSURE_DICT(options);
    [TestFlight setOptions:options];
    return nil;
}*/

@end
