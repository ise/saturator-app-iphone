//
//  DetailViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize webView = _webView;
Article *article;
bool isTop = false;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setArticle:(Article *)a
{
    article = a;
}

- (void)setTopPage:(BOOL)top
{
    isTop = top;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //navigationbarを表示
    self.navigationController.navigationBarHidden = NO;
    //tabbarは非表示
    ((UITabBarController *)self.parentViewController.parentViewController).tabBar.hidden = YES;
    NSURL *url;
    if (isTop) {
        NSLog(@"Request to %@", article.feedUrl);
        url = [NSURL URLWithString:article.feedUrl];
    } else {
        NSLog(@"Request to %@", article.url);
        url = [NSURL URLWithString:article.url];
    }
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
