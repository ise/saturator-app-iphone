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
#import "LINEActivity.h"
#import "ARChromeActivity.h"
#import "EGYModalWebViewController.h"
#import "SimpleWebViewController.h"
#import "TUSafariActivity.h"

@implementation DetailViewController

@synthesize backBarButtonItem, forwardBarButtonItem, refreshBarButtonItem, stopBarButtonItem, actionBarButtonItem, rdbBarButtonItem;
@synthesize webView = _webView;


Article *article;
bool isTop = NO;
bool showLoad = YES;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //navigationbarを表示
    self.navigationController.navigationBarHidden = NO;
    
    //tabbarは非表示
    ((UITabBarController *)self.parentViewController.parentViewController).tabBar.hidden = YES;
    
    //toolbar表示
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    showLoad = YES;
    
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
    
    [self updateToolbarItems];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.webView = nil;
    backBarButtonItem = nil;
    forwardBarButtonItem = nil;
    refreshBarButtonItem = nil;
    stopBarButtonItem = nil;
    actionBarButtonItem = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (showLoad) {
        [SVProgressHUD show];
        showLoad = NO;
    }
    [self updateToolbarItems];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    [self updateToolbarItems];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self updateToolbarItems];
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

- (void)_removeBookmark
{
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSError *error = nil;
        NSString *pattern = article.feedUrl;
        NSURL *url = [request URL];
        NSRegularExpression *r = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger s = [r numberOfMatchesInString:url.absoluteString options:0 range:NSMakeRange(0, url.absoluteString.length)];
        if (s <= 0) {
            [[UIApplication sharedApplication] openURL: url];
            return NO;
        }
    }
    
    return YES;
}

- (UIBarButtonItem *)backBarButtonItem
{
    if (!backBarButtonItem) {
        backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"EGYWebViewController.bundle/iPhone/back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClicked:)];
        backBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		backBarButtonItem.width = 18.0f;
    }
    return backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem
{
    if (!forwardBarButtonItem) {
        forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"EGYWebViewController.bundle/iPhone/forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardClicked:)];
        forwardBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		forwardBarButtonItem.width = 18.0f;
    }
    return forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem
{
    
    if (!refreshBarButtonItem) {
        refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)];
    }
    
    return refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem
{
    
    if (!stopBarButtonItem) {
        stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopClicked:)];
    }
    return stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem
{
    
    if (!actionBarButtonItem) {
        actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonClicked:)];
    }
    return actionBarButtonItem;
}

- (UIBarButtonItem *)rdbBarButtonItem
{
    if (!rdbBarButtonItem) {
        rdbBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Readability-activity-iPhone"] style:UIBarButtonItemStylePlain target:self action:@selector(rdbClicked:)];
        rdbBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		rdbBarButtonItem.width = 18.0f;
    }
    return rdbBarButtonItem;
}

- (void)updateToolbarItems
{
    self.backBarButtonItem.enabled = self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.webView.canGoForward;
    //self.actionBarButtonItem.enabled = !self.webView.isLoading;
    self.actionBarButtonItem.enabled = YES;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 5.0f;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    NSArray *items;

    items = [NSArray arrayWithObjects:
             fixedSpace,
             self.backBarButtonItem,
             flexibleSpace,
             self.forwardBarButtonItem,
             flexibleSpace,
             refreshStopBarButtonItem,
             flexibleSpace,
             self.actionBarButtonItem,
             flexibleSpace,
             self.rdbBarButtonItem,
             fixedSpace,
             nil];
    self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
    self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
    self.toolbarItems = items;
}


- (void)goBackClicked:(UIBarButtonItem *)sender
{
    [self.webView goBack];
}

- (void)goForwardClicked:(UIBarButtonItem *)sender
{
    [self.webView goForward];
}

- (void)reloadClicked:(UIBarButtonItem *)sender
{
    [self.webView reload];
}

- (void)stopClicked:(UIBarButtonItem *)sender
{
    [self.webView stopLoading];
	[self updateToolbarItems];
}

- (void)rdbClicked:(UIBarButtonItem *)sender
{
    NSURL *cur = self.webView.request.URL;
    NSString *rdbUrl = @"http://www.readability.com/m?url=";
    NSURL *url = [[NSURL alloc] initWithString:[rdbUrl stringByAppendingString:[cur absoluteString]]];
    /*
    SimpleWebViewController *swv = [[SimpleWebViewController alloc] initWithNibName:@"SimpleWebViewController" bundle:nil];
    [swv setTargetUrl:url];
    swv.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController: swv animated:YES completion: nil];
     */
    EGYModalWebViewController *wvc = [[EGYModalWebViewController alloc] initWithURL:url];
    wvc.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:wvc animated:YES completion:nil];
}

- (void)actionButtonClicked:(id)sender
{
    NSURL *url = self.webView.request.URL;
    //NSString *text = [NSString stringWithFormat:@"This link shared from %@ Application", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]];

    NSArray *activityItems;
    activityItems = @[url, url.absoluteString];
    
    TUSafariActivity *safari = [[TUSafariActivity alloc] init];
    LINEActivity *line = [[LINEActivity alloc] init];
    ARChromeActivity *chrome = [[ARChromeActivity alloc] init];
    NSArray *activities = @[
                            safari,
                            line,
                            chrome
                            ];
    
    // UIActivityViewController
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:activities];
    [self presentViewController:activityView animated:YES completion:nil];
}

@end
