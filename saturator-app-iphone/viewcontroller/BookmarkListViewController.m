//
//  BookmarkListViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "BookmarkListViewController.h"
#import "AnimeDataManager.h"
#import "SVProgressHUD.h"

@implementation BookmarkListViewController

- (void)_setHeaderViewHidden:(BOOL)hidden animated:(BOOL)animated
{
    CGFloat topOffset = 0.0;
    topOffset = -self.headerView.frame.size.height;
    self.tableView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);
}

- (void)_initEmptyView
{
    CGFloat marginX = self.view.frame.size.width - self.emptyView.frame.size.width;
    CGFloat marginY = self.view.frame.size.height - self.emptyView.frame.size.height;
    self.emptyView.frame = CGRectMake(marginX / 2.0f, marginY / 2.0f, self.emptyView.frame.size.width, self.emptyView.frame.size.height);
    self.emptyView.message.text = @"ブックマークされた記事はありません";
}

- (void)viewDidLoad
{
    [self _setHeaderViewHidden:YES animated:NO];
    self.tableView.tableHeaderView = self.headerView;
    [self _initEmptyView];
    [self.view addSubview:self.emptyView];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hasNext = NO;
    [self loadArticles:0];
}

- (void)loadArticles:(int)page
{
    ArticleDataManager *manager = [ArticleDataManager sharedInstance];
    self.emptyView.hidden = YES;
    [manager loadBookmarks:self];
}

- (void)buildView:(NSMutableArray *)articles
{
    self.articleList = articles;
    if (articles.count == 0) {
        self.emptyView.hidden = NO;
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"記事が見つかりませんでした" delegate:self cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:alert repeats:NO];
        [alert show];
         */
    }
    [self.tableView reloadData];
}

- (void)_taskFinished
{
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

//リストを引き下げて更新する
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

@end
