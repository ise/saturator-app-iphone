//
//  GestureWindow.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/03/28.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "GestureWindow.h"


@implementation GestureWindow

@synthesize wView;
@synthesize wDelegate;

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    if (self.wView == nil || self.wDelegate == nil) {
        return;
    }
    NSSet *touches = [event allTouches];
    if (touches.count != 1) {
        return;
    }
    UITouch *touch = touches.anyObject;
    // 指定のUIWebViewへのタッチか
    if ([touch.view isDescendantOfView:self.wView] == NO) {
        return;
    }
    switch (touch.phase) {
        case UITouchPhaseBegan:
            if ([self.wDelegate
                 respondsToSelector:@selector(touchesBeganWeb:withEvent:)]) {
                [self.wDelegate
                 performSelector:@selector(touchesBeganWeb:withEvent:)
                 withObject:touches withObject:event];
            }
            break;
        case UITouchPhaseMoved:
            if ([self.wDelegate
                 respondsToSelector:@selector(touchesMovedWeb:withEvent:)]) {
                [self.wDelegate
                 performSelector:@selector(touchesMovedWeb:withEvent:)
                 withObject:touches withObject:event];
            }
            break;
        case UITouchPhaseEnded:
            if ([self.wDelegate
                 respondsToSelector:@selector(touchesEndedWeb:withEvent:)]) {
                [self.wDelegate
                 performSelector:@selector(touchesEndedWeb:withEvent:)
                 withObject:touches withObject:event];
            }
        default:
            return;
            break;
    }
}

@end
