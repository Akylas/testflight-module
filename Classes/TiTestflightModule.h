/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"

@interface TiTestflightModule : TiModule 
{
}

@property(nonatomic,readonly) NSString *OPTION_DISABLE_INAPP_UPDATES; // Defaults to @NO. Setting to @YES, disables the in app update screen shown in BETA apps when there is a new version available on TestFlight.
@property(nonatomic,readonly) NSString *OPTION_FLUSH_SECOND_INTERVAL; // Defaults to @60. Set to a number. @0 turns off the flush timer. 30 seconds is the minimum flush interval.
@property(nonatomic,readonly) NSString *OPTION_LONG_ON_CHECKPOINT; // Defaults to @YES. Because logging is synchronous, if you have a high preformance app, you might want to turn this off.
@property(nonatomic,readonly) NSString *OPTION_LOG_TO_CONSOLE; // Defaults to @YES. Prints remote logs to Apple System Log.
@property(nonatomic,readonly) NSString *OPTION_LOG_TO_SDTERR; // Defaults to @YES. Sends remote logs to STDERR when debugger is attached.
@property(nonatomic,readonly) NSString *OPTION_REINSTALL_CRASH_HANDLERS; // If set to @YES: Reinstalls crash handlers, to be used if a third party library installs crash handlers overtop of the TestFlight Crash Handlers.
@property(nonatomic,readonly) NSString *OPTION_REPORT_CRASHES; // Defaults to @YES. If set to @NO, crash handlers are never installed. Must be set **before** calling `takeOff:`.
@property(nonatomic,readonly) NSString *OPTION_SEND_ONLY_ON_CRASH; // Defaults to @NO. Setting to @YES stops remote logs from being sent when sessions end. They would only be sent in the event of a crash.
@property(nonatomic,readonly) NSString *OPTION_SESSION_KEEP_ALIVE_TIMEOUT; // Defaults to @30. This is the amount of time a user can leave the app for and still continue the same session when they come back. If they are away from the app for longer, a new session is created when they come back. Must be a number. Change to @0 to turn off.
@property(nonatomic,readonly) NSString *OPTION_ASYNC_LOG;

@end
