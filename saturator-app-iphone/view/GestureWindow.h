//
//  GestureWindow.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/03/28.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

@protocol GestureWindowDelegate

- (void) touchesBeganWeb:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesMovedWeb:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesEndedWeb:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface GestureWindow : UIWindow {
    UIWebView* view;
    id delegate;
}

@property (nonatomic, retain) UIWebView* wView;
@property (nonatomic, assign) id wDelegate;

@end
