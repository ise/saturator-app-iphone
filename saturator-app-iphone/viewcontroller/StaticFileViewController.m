//
//  StaticFileViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/05/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "StaticFileViewController.h"

@implementation StaticFileViewController

@synthesize webView = _webView;

int type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    NSString *name;
    if (type == 0) {
        name = @"help";
        self.navigationItem.title = @"ヘルプ";
    } else if (type == 1) {
        name = @"license";
        self.navigationItem.title = @"ライセンス";
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    ((UITabBarController *)self.parentViewController.parentViewController).tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setType:(int)t
{
    type = t;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if([[[request URL] scheme] isEqual:@"mailto"]){
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL: [request URL]];
        return NO;
    }
    
    return YES;
}

@end
