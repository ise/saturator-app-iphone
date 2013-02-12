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

- (void)viewDidLoad
{
    [super viewDidLoad];
    ((UITabBarController *)self.parentViewController.parentViewController).tabBar.hidden = YES;
    NSLog(@"Request to %@", article.url);
    NSURL *url = [NSURL URLWithString:article.url];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
