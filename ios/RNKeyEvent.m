
#import <Foundation/Foundation.h>
#import "RNKeyEvent.h"

NSString* const onKeyUpEvent = @"onKeyUp";

@implementation RNKeyEvent

#pragma mark - RNKeyEvent implementation

RCT_EXPORT_MODULE();

+ (id)allocWithZone:(NSZone *)zone {
    static RNKeyEvent *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

+ (id)getSingletonInstance {
    static RNKeyEvent *sharedRNKeyEvent = nil;
    if (sharedRNKeyEvent == nil) {
        sharedRNKeyEvent = [[self alloc] init];
    }
    return sharedRNKeyEvent;
}

- (BOOL)isListening {
    return self.hasListeners;
}

// Updating the keystorke required for number pad to work ( seprator should be ", ")
- (NSString *)getKeys {
    return  [NSString stringWithFormat:@"! ,. ,, ,\b ,1 ,2 ,3 ,4 ,5 ,6 ,7 ,8 ,9 ,0 ,\r,%@,%@,%@,%@",UIKeyInputLeftArrow, UIKeyInputRightArrow, UIKeyInputUpArrow, UIKeyInputDownArrow];
}

- (void)sendKeyEvent:(NSString *)keyString {
    if (self.hasListeners && self.bridge) {
        [super sendEventWithName:onKeyUpEvent body:@{@"pressedKey": keyString}];
    }
}

#pragma mark - Exported to JavaScript methods

#pragma mark - RCTEventEmitter implementation

- (NSArray<NSString *> *)supportedEvents {
    return @[onKeyUpEvent];
}

// Note: startObserving will be called when this module's first listener is added.
- (void)startObserving {
    self.hasListeners = YES;
    // Set up any upstream listeners or background tasks as necessary
}

// Note: stopObserving will be called when this module's last listener is removed, or on dealloc.
- (void)stopObserving {
    self.hasListeners = NO;
    // Remove upstream listeners, stop unnecessary background tasks
}

@end

