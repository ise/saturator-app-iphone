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
    [self _setBookmarkButton];

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

- (void)_setBookmarkButton
{
    ArticleDataManager *m = [ArticleDataManager sharedInstance];
    BOOL isBookmarked = [m isBookmarked:article.url];
    if (isBookmarked) {
        UIBarButtonItem *del = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(_removeBookmark)];
        self.navigationItem.rightBarButtonItem = del;
    } else {
        UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_addBookmark)];
        self.navigationItem.rightBarButtonItem = add;
    }
}

- (void)_removeBookmark {
    ArticleDataManager *m = [ArticleDataManager sharedInstance];
    int res = [m removeBookmark:article.url];
    NSLog(@"res=%d", res);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:article.url forKey:@"url"];
    [dic setObject:[NSNumber numberWithInt:res] forKey:@"bookmarked"];
    NSNotification *n = [NSNotification notificationWithName:@"UpdateBookmarkStatus" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:n];
    [self _setBookmarkButton];
}

- (void)_addBookmark {
    ArticleDataManager *m = [ArticleDataManager sharedInstance];
    int res = [m addBookmark:article.url];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:article.url forKey:@"url"];
    [dic setObject:[NSNumber numberWithInt:res] forKey:@"bookmarked"];
    NSNotification *n = [NSNotification notificationWithName:@"UpdateBookmarkStatus" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:n];
    [self _setBookmarkButton];
}

@end
