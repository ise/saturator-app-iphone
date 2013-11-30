//
//  SimpleWebViewController.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/11/30.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleWebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL *)url;
- (void)setTargetUrl:(NSURL *)url;

@end
