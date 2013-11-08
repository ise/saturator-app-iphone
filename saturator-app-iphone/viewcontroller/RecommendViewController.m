//
//  RecommendViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/03/20.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "RecommendViewController.h"
#import "SVProgressHUD.h"
#import "AnimeDataManager.h"

@implementation RecommendViewController

@synthesize webView = _webView;

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webView.frame.size.width, self.webView.frame.size.height - self.tabBarController.rotatingFooterView.bounds.size.height);
    self.webView.delegate = self;
    
    NSMutableArray *tids = [[AnimeDataManager sharedInstance] getFavorites];
    NSMutableArray *params = [NSMutableArray array];
    for (NSString *tid in tids) {
        [params addObject:[NSString stringWithFormat:@"tid[]=%@", tid]];
    }
    NSString *urlStr = [NSString stringWithFormat:@"http://saturator.info/recommend?%@", [params componentsJoinedByString:@"&"]];
    NSURL *url;
    url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView setScalesPageToFit:YES];
    [self.webView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL: [request URL]];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

@end
