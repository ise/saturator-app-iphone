//
//  DetailViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "DetailViewController.h"
#import "ArticleDataManager.h"

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
    [self _setClipButton];

    //tabbarは非表示
    ((UITabBarController *)self.parentViewController.parentViewController).tabBar.hidden = YES;
    NSURL *url;
    if (isTop) {
        NSLog(@"Request to %@", article.feedUrl);
        url = [NSURL URLWithString:article.feedUrl];
        self.navigationItem.title = article.feedName;
    } else {
        NSLog(@"Request to %@", article.url);
        url = [NSURL URLWithString:article.url];
        self.navigationItem.title = article.title;
    }
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_setClipButton
{
    ArticleDataManager *m = [ArticleDataManager sharedInstance];
    BOOL isClipped = [m isClipped:article.url];
    if (isClipped) {
        UIBarButtonItem *del = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(_removeClip)];
        self.navigationItem.rightBarButtonItem = del;
    } else {
        UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_addClip)];
        self.navigationItem.rightBarButtonItem = add;
    }
}

- (void)_removeClip {
    ArticleDataManager *m = [ArticleDataManager sharedInstance];
    int res = [m removeClip:article.url];
    NSLog(@"res=%d", res);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:article.url forKey:@"url"];
    [dic setObject:[NSNumber numberWithInt:res] forKey:@"clipped"];
    NSNotification *n = [NSNotification notificationWithName:@"UpdateClipStatus" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:n];
    [self _setClipButton];
}

- (void)_addClip {
    ArticleDataManager *m = [ArticleDataManager sharedInstance];
    int res = [m addClip:article.url];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:article.url forKey:@"url"];
    [dic setObject:[NSNumber numberWithInt:res] forKey:@"clipped"];
    NSNotification *n = [NSNotification notificationWithName:@"UpdateClipStatus" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:n];
    [self _setClipButton];
}

@end
