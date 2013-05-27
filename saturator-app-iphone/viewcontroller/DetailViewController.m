//
//  DetailViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "DetailViewController.h"
#import "ArticleDataManager.h"
#import "SVProgressHUD.h"

@implementation DetailViewController

@synthesize webView = _webView;
Article *article;
bool isTop = false;
NSMutableArray* touchPoints;
CGFloat initX;
CGFloat initY;


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
    
    touchPoints = [[NSMutableArray alloc] init];
    
    // タッチイベントをフックするUIWindow
    GestureWindow* tapWindow;
    tapWindow = (GestureWindow*)[[UIApplication sharedApplication].windows
                                 objectAtIndex:0];
    tapWindow.wView = self.webView;
    tapWindow.wDelegate = self;
    
    //navigationbarを表示
    self.navigationController.navigationBarHidden = NO;
    
    //tabbarは非表示
    ((UITabBarController *)self.parentViewController.parentViewController).tabBar.hidden = YES;
    NSURL *url;
    if (isTop) {
        url = [NSURL URLWithString:article.feedUrl];
        self.navigationItem.title = article.feedName;
    } else {
        url = [NSURL URLWithString:article.url];
        self.navigationItem.title = article.title;
        [self _setBookmarkButton];
    }
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:req];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //GestureWindowのdelegateを初期化
    GestureWindow* tapWindow;
    tapWindow = (GestureWindow*)[[UIApplication sharedApplication].windows
                                 objectAtIndex:0];
    tapWindow.wView = nil;
    tapWindow.wDelegate = nil;
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //[SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[SVProgressHUD dismiss];
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

- (void) touchesBeganWeb:(NSSet *)touches withEvent:(UIEvent *)event {
    //タッチ開始時の座標保存
    NSArray *twoTouches = [touches allObjects];
    UITouch *first = [twoTouches objectAtIndex:0];
    initX = [first locationInView:self.view].x;
    initY = [first locationInView:self.view].y;
}

- (void) touchesMovedWeb:(NSSet *)touches withEvent:(UIEvent *)event {
    //スワイプ動作を検出する
    NSArray *twoTouches = [touches allObjects];
    UITouch *first = [twoTouches objectAtIndex:0];
    CGFloat x = [first locationInView:self.view].x - initX;
    CGFloat y = [first locationInView:self.view].y - initY;
    
    if (x > GESTURE_LENGTH && y < BLUR_LENGTH) {
        //[self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) touchesEndedWeb:(NSSet *)touches withEvent:(UIEvent *)event {

    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL: [request URL]];
        return NO;
    }
    
    return YES;
}

@end
