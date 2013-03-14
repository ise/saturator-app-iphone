//
//  ClipListViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "ClipListViewController.h"
#import "AnimeDataManager.h"
#import "SVProgressHUD.h"

@implementation ClipListViewController

- (void)viewDidLoad
{
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hasNext = NO;
    [self loadArticles:0];
}

- (void)loadArticles:(int)page
{
    NSLog(@"loadArticles page=%d", page);
    ArticleDataManager *manager = [ArticleDataManager sharedInstance];
    [manager loadClips:self];
}

- (void)buildView:(NSMutableArray *)articles
{
    NSLog(@"buildView");
    self.articleList = articles;
    NSLog(@"dismiss");
    if (articles.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"記事が見つかりませんでした" delegate:self cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:alert repeats:NO];
        [alert show];
    }
    [self.tableView reloadData];
}

@end
