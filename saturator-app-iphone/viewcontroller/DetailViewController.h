//
//  DetailViewController.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "GestureWindow.h"

#define GESTURE_LENGTH  5
#define BLUR_LENGTH     5
#define PINCH_DELTA     100

@interface DetailViewController : UIViewController <UIWebViewDelegate,GestureWindowDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (void)setArticle:(Article *)a;
- (void)setTopPage:(BOOL)top;
@end
