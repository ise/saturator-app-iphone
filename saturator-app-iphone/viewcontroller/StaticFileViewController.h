//
//  StaticFileViewController.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/05/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticFileViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (void)setType:(int)type;
@end
