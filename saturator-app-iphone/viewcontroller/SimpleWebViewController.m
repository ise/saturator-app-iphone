//
//  SimpleWebViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/11/30.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "SimpleWebViewController.h"

@implementation SimpleWebViewController

@synthesize webView = _webView;

NSURL *targetUrl;// = [[NSURL alloc] initWithString:@"http://www.yahoo.co.jp/"];

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL *)url
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    targetUrl = url;
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"SimpleWebViewController");
    NSLog(@"%@", targetUrl);
    self.webView.delegate = self;
    [super viewDidLoad];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:targetUrl];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:req];
}

- (void)setTargetUrl:(NSURL *)url
{
    targetUrl = url;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)doneButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
