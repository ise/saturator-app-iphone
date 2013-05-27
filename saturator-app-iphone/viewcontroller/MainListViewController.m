//
//  MainListViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/04.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "MainListViewController.h"
#import "MainListViewCellController.h"
#import "MainListViewCellWithoutImageController.h"
#import "MainLIstViewFooterCellController.h"
#import "MainListAuthorViewCellController.h"
#import "DetailViewController.h"
#import "Article.h"
#import "BaseListViewCell.h"
#import "ArticleDataManager.h"
#import "AnimeDataManager.h"
#import "ConfigDataManager.h"
#import "InitialAnimeListViewController.h"

#import "SVProgressHUD.h"

@implementation MainListViewController

@synthesize headerView;
@synthesize emptyView;
@synthesize footerView;
@synthesize articleList;

int currentPage;
BOOL isRefresh = NO;
int itemType = MainListItemTypeAll;

- (void)_setHeaderViewHidden:(BOOL)hidden animated:(BOOL)animated
{
    CGFloat topOffset = 0.0;
    if (hidden) {
        topOffset = -self.headerView.frame.size.height;
    }
    if (animated) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.tableView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);
                         }];
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);
    }
}

- (void)_initEmptyView
{
    CGFloat marginX = self.view.frame.size.width - self.emptyView.frame.size.width;
    CGFloat marginY = self.view.frame.size.height - self.emptyView.frame.size.height;
    self.emptyView.frame = CGRectMake(marginX / 2.0f, marginY / 2.0f, self.emptyView.frame.size.width, self.emptyView.frame.size.height);
    self.emptyView.message.text = @"記事がありません\nリストを下方向に引き下げると更新できます";
}

- (void)_initFooterView
{
    self.footerView.message.text = @"Load next posts ...";
    [self.footerView setListView:self];
}

- (id)init
{
    self = [super initWithNibName:@"MainListViewController" bundle:nil];
    if (self) {
        self.articleList = [[NSMutableArray alloc] init];
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
        
        [self _initStatus];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.articleList = [[NSMutableArray alloc] init];
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
        
        [self _initStatus];
    }
    return self;
}

- (void)_initStatus
{
    currentPage = 1;
    //[self.articleList removeAllObjects];
    self.emptyView.hidden = YES;
    //self.tableView.tableFooterView.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //広告準備
    self.nadView = [[NADView alloc] init];
    [self.nadView setIsOutputLog:NO];
    [self.nadView setNendID:@"574031920552c3db563238e10a6cd868595095da" spotID:@"55043"];
    [self.nadView setDelegate:self];
    [self.nadView load];
    
    
    ConfigDataManager *m = [ConfigDataManager sharedInstance];
    itemType = [m getMainListItemType];
    
    //リスト表示項目変更時の通知を設定
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(updateItemType) name:@"UpdateItemType" object:nil];
    //ブックマーク通知設定
    [nc addObserver:self selector:@selector(updateBookmarkStatus:) name:@"UpdateBookmarkStatus" object:nil];
    [nc addObserver:self selector:@selector(updateArticleStatus:) name:@"UpdateArticleStatus" object:nil];
    
    //各viewの設定
    [self _setHeaderViewHidden:YES animated:NO];
    self.tableView.tableHeaderView = self.headerView;
    [self _initEmptyView];
    [self.view addSubview:self.emptyView];
    [self _initFooterView];
    self.tableView.tableFooterView = self.footerView;
    self.tableView.tableFooterView.hidden = YES;
    
    
    //記事の読み込みを開始
    NSMutableArray *tids = [[AnimeDataManager sharedInstance] getFavorites];
    if (tids.count > 0) {
        [self loadArticles:1];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.nadView resume];
    
    //navigationbar非表示に
    self.navigationController.navigationBarHidden = YES;
    //tabbarは表示
    ((UITabBarController *)self.parentViewController.parentViewController).tabBar.hidden = NO;
    AnimeDataManager *m = [AnimeDataManager sharedInstance];
    if (m.updatedFavorite) {
        [self refresh:nil];
        m.updatedFavorite = NO;
    }
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSMutableArray *tids = [[AnimeDataManager sharedInstance] getFavorites];
    if (tids.count <= 0) {
        InitialAnimeListViewController *initViewController = [[InitialAnimeListViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:initViewController];
        [self presentViewController:nc animated:NO completion:^{}];
    }
}

- (void)nadViewDidFinishLoad:(NADView *)adView
{
    [self.nadView setFrame:CGRectMake(0.f, self.view.bounds.size.height - self.tabBarController.rotatingFooterView.bounds.size.height + 15, NAD_ADVIEW_SIZE_320x50.width, NAD_ADVIEW_SIZE_320x50.height)];
    [self.parentViewController.view addSubview:self.nadView];
}

- (void)nadViewDidReceiveAd:(NADView *)adView
{
}

-(void)nadViewDidFailToReceiveAd:(NADView *)adView
{
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.nadView pause];
    if (!self.nadView.isHidden) {
        self.nadView.hidden = YES;
    }
}

- (void)dealloc
{
    [self.nadView setDelegate:nil];
    self.nadView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = self.articleList.count;
    if (count == 0) {
        return 0;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //広告表示を制御
    NSArray *visibles = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *last = [visibles objectAtIndex:visibles.count - 1];
    if (last.section >= self.articleList.count - 1) {
        [self.nadView setHidden:YES];
    } else if ([self.nadView isHidden]) {
        [self.nadView setHidden:NO];
    }
    
    BaseListViewCell *cell;
    Article *article = [self.articleList objectAtIndex:indexPath.section];
    if (indexPath.row % 2 == 0) {
        if ([article.image isEqualToString:@""] || itemType == MainListItemTypeTitle){
            //画像が無い場合
            static NSString *CellIdentifier = @"MainListViewCellWithoutImage";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                MainListViewCellWithoutImageController *controller = [[MainListViewCellWithoutImageController alloc] initWithNibName:@"MainListViewCellWithoutImageController" bundle:nil];
                cell = (MainListViewCellWithoutImage *)controller.view;
            }
        } else {
            //画像がある場合
            static NSString *CellIdentifier = @"MainListViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                MainListViewCellController *controller = [[MainListViewCellController alloc] initWithNibName:@"MainListViewCellController" bundle:nil];
                cell = (MainListViewCell *)controller.view;
            }
        }
    } else {
        static NSString *CellIdentifier = @"MainListAuthorViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            MainListAuthorViewCellController *controller = [[MainListAuthorViewCellController alloc] initWithNibName:@"MainListAuthorViewCellController" bundle:nil];
            cell = (MainListAuthorViewCell *)controller.view;
        }
    }
    [cell setArticle:article delegate:self];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        Article *article = [self.articleList objectAtIndex:indexPath.section];
        if ([article.image isEqualToString:@""] || itemType == MainListItemTypeTitle) {
            //画像なし
            return 110;
        }
        return 278;
    } else {
        return 60;
    }
}

#define PULLDOWN_MARGIN -15.0f

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.headerView.state == HeaderViewStateStopping) {
        //更新中
        return;
    }
    
    CGFloat threshold = self.headerView.frame.size.height;
    
    if (PULLDOWN_MARGIN <= scrollView.contentOffset.y &&
        scrollView.contentOffset.y < threshold) {
        //引き下げ中だが更新はしない状態
        self.headerView.state = HeaderViewStatePullingDown;
    } else if (scrollView.contentOffset.y < PULLDOWN_MARGIN) {
        //引き下げ中で更新を行う状態
        self.headerView.state = HeaderViewStateOveredThreshold;
    } else {
        //引き下げてない状態
        self.headerView.state = HeaderViewStateHidden;
    }
}

//リストを引き下げて更新する
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    if (self.tableView.contentOffset.y < PULLDOWN_MARGIN) {
    if (self.headerView.state == HeaderViewStateOveredThreshold) {
        self.headerView.state = HeaderViewStateStopping;
        [self _setHeaderViewHidden:NO animated:YES];
        
        isRefresh = YES;
        [self refresh:nil];
    }
}

- (void)_taskFinished
{
    self.headerView.state = HeaderViewStateHidden;
    [self _setHeaderViewHidden:YES animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        //記事への遷移
        DetailViewController *detail = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        [detail setArticle:[self.articleList objectAtIndex:indexPath.section]];
        [detail setTopPage:false];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    } else {
        //フィードトップへの遷移
        DetailViewController *detail = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        [detail setArticle:[self.articleList objectAtIndex:indexPath.section]];
        [detail setTopPage:true];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)buildErrorView
{
    //UIAlertView *alert = [[UIAlertView alloc] init];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"データを取得できませんでした" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
    if (isRefresh) {
        isRefresh = NO;
        [self _taskFinished];
    }
    [SVProgressHUD dismiss];
    [alert show];
    self.emptyView.hidden = NO;
}

- (void)buildView:(NSMutableArray *)articles
{
    if (isRefresh) {
        isRefresh = NO;
        [self _taskFinished];
        [self.articleList removeAllObjects];
    }
    [self.articleList addObjectsFromArray:articles];
    [SVProgressHUD dismiss];
    if (articles.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"記事が見つかりませんでした" delegate:self cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:alert repeats:NO];
        [alert show];
        self.tableView.tableFooterView.hidden = YES;
        self.hasNext = NO;
    } else {
        self.tableView.tableFooterView.hidden = NO;
    }
    [self.tableView reloadData];
    
    currentPage++;
}

//アラートを時限式で閉じる
- (void)performDismiss:(NSTimer *)theTimer
{
    UIAlertView *alertView = [theTimer userInfo];
    [alertView dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)loadArticles:(int)page
{
    ArticleDataManager *manager = [ArticleDataManager sharedInstance];
    NSMutableArray *tids = [[AnimeDataManager sharedInstance] getFavorites];
    
    
    if (tids.count == 0) {
        [tids addObject:@"2825"];
    }
    
    
    [manager updateList:self Tids:tids Page:page Retry:3];
    
    [SVProgressHUD show];
}

- (void)refresh:(id)selector
{
    [self _initStatus];
    [self.tableView reloadData];
    [self loadArticles:1];
}

- (void)loadNextPosts
{
    [self loadArticles:currentPage];
}

- (void)updateItemType
{
    ConfigDataManager *m = [ConfigDataManager sharedInstance];
    itemType = [m getMainListItemType];
    [self.tableView reloadData];
}

- (void)updateBookmarkStatus:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *url = [dic objectForKey:@"url"];
    NSNumber *bookmarked = [dic objectForKey:@"bookmarked"];
    
    for (int i=0; i<self.articleList.count; i++) {
        Article *a = [self.articleList objectAtIndex:i];
        if ([a.url isEqualToString:url]) {
            a.bookmarked = [bookmarked intValue];
        }
        [self.articleList replaceObjectAtIndex:i withObject:a];
    }
    [self.tableView reloadData];
}

- (void)updateArticleStatus:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    Article *article = [dic objectForKey:@"article"];
    
    for (int i=0; i<self.articleList.count; i++) {
        Article *a = [self.articleList objectAtIndex:i];
        if ([a.url isEqual:article.url]) {
            [self.articleList replaceObjectAtIndex:i withObject:article];
            break;
        }
    }
}

@end
