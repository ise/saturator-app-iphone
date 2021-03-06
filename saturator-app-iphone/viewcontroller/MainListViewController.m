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
#import "Anime.h"
#import "BaseListViewCell.h"
#import "ArticleDataManager.h"
#import "AnimeDataManager.h"
#import "ConfigDataManager.h"
#import "InitialAnimeListViewController.h"

#import "SVProgressHUD.h"

@implementation MainListViewController

@synthesize emptyView;
@synthesize footerView;
@synthesize articleList;
@synthesize targetAnime;

int currentPage;
BOOL isRefresh = NO;
int itemType = MainListItemTypeAll;

- (void)_initEmptyView
{
    CGFloat marginX = self.view.frame.size.width - self.emptyView.frame.size.width;
    CGFloat marginY = self.view.frame.size.height - self.emptyView.frame.size.height;
    self.emptyView.frame = CGRectMake(marginX / 2.0f, marginY / 2.0f, self.emptyView.frame.size.width, self.emptyView.frame.size.height);
    self.emptyView.message.text = @"記事がありません\nリストを下方向に引き下げると更新できます";
}

- (void)_initFooterView
{
    self.footerView.message.text = @"more ...";
    [self.footerView setListView:self];
}

- (void)setAnime:(Anime *)a
{
    //NSLog(@"setAnime");
    self.targetAnime = a;
}

- (id)init
{
    self = [super initWithNibName:@"MainListViewController" bundle:nil];
    if (self) {
        self.articleList = [[NSMutableArray alloc] init];
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg3.png"]];
        
        [self _initStatus];
    }
    return self;
}

- (id)initWithAnime:(Anime *)anime
{
    //NSLog(@"initWithAnime");
    self = [super initWithNibName:@"MainListViewController" bundle:nil];
    [self setAnime:anime];
    if (self) {
        self.articleList = [[NSMutableArray alloc] init];
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg3.png"]];
        
        [self _initStatus];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.articleList = [[NSMutableArray alloc] init];
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg3.png"]];
        
        [self _initStatus];
    }
    return self;
}

- (void)_initStatus
{
    currentPage = 1;
    //[self.articleList removeAllObjects];
    self.emptyView.hidden = YES;
    self.hasNext = YES;
}

- (void)viewDidLoad
{
    //NSLog(@"MainListViewController.viewDidLoad");
    [super viewDidLoad];
    
    //広告準備
    self.nadView = [[NADView alloc] init];
    [self.nadView setIsOutputLog:YES];
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
    //お気に入り更新通知設定
    [nc addObserver:self selector:@selector(updateFavoriteTitle:) name:@"UpdateFavoriteTitle" object:nil];
    
    //各viewの設定
    [self _initEmptyView];
    [self.view addSubview:self.emptyView];
    [self _initFooterView];
    self.tableView.tableFooterView = self.footerView;
    self.tableView.tableFooterView.hidden = YES;
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    [rc addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
    
    //記事の読み込みを開始
    NSMutableArray *tids = [self _getCurrentTids];
    if (tids.count > 0) {
        [self loadArticles:1];
    }
}

- (NSMutableArray *)_getCurrentTids
{
    NSMutableArray *tids = [NSMutableArray array];
    if (self.targetAnime != nil) {
        [tids addObject:self.targetAnime.tid];
    } else {
        tids = [[AnimeDataManager sharedInstance] getFavorites];
    }
    return tids;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.nadView resume];
    
    if (self.targetAnime == nil) {
        //navigationbar非表示に
        //NSLog(@"MainListViewController navigationBarHidden");
        self.navigationController.navigationBarHidden = YES;
    } else {
        self.navigationController.navigationBarHidden = NO;
        self.navigationItem.title = self.targetAnime.title;
    }
    //tabbarは表示
    ((UITabBarController *)self.parentViewController.parentViewController).tabBar.hidden = NO;
    AnimeDataManager *m = [AnimeDataManager sharedInstance];
    if (m.updatedFavorite) {
        isRefresh = YES;
        [self refresh:nil];
        m.updatedFavorite = NO;
    }
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSMutableArray *tids = [self _getCurrentTids];
    //NSMutableArray *tids = [[AnimeDataManager sharedInstance] getFavorites];
    if (tids.count <= 0) {
        @try {
            InitialAnimeListViewController *initViewController = [[InitialAnimeListViewController alloc] init];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:initViewController];
            [self presentViewController:nc animated:NO completion:^{}];
        }
        @catch (NSException *exception) {
            //NSLog(@"Exception.reason=%@", exception.reason);
        }
        @finally {
            
        }
    }
}

- (void)nadViewDidFinishLoad:(NADView *)adView
{
    //NSLog(@"nadViewDidFnisheLoad");
    if (self.targetAnime == nil) {
        [self.nadView setFrame:CGRectMake(0.f, self.view.bounds.size.height - self.tabBarController.rotatingFooterView.bounds.size.height - 51, NAD_ADVIEW_SIZE_320x50.width, NAD_ADVIEW_SIZE_320x50.height)];
    } else {
        [self.nadView setFrame:CGRectMake(0.f, self.view.bounds.size.height - self.tabBarController.rotatingFooterView.bounds.size.height - 51, NAD_ADVIEW_SIZE_320x50.width, NAD_ADVIEW_SIZE_320x50.height)];
    }

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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"データを取得できませんでした\nインターネット接続を確認してください" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
    if (isRefresh) {
        isRefresh = NO;
    }
    [SVProgressHUD dismiss];
    [alert show];
    self.emptyView.hidden = NO;
}

- (void)buildView:(NSMutableArray *)articles
{
    if (isRefresh) {
        isRefresh = NO;
        [self.articleList removeAllObjects];
    }
    [self.articleList addObjectsFromArray:articles];
    
    //読み込み完了
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
    //NSLog(@"buildview");
    
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
    //NSMutableArray *tids = [[AnimeDataManager sharedInstance] getFavorites];
    NSMutableArray *tids = [self _getCurrentTids];
    
    
    if (tids.count == 0) {
        [tids addObject:@"2825"];
    }
    
    
    [manager updateList:self Tids:tids Page:page Retry:3];
    [SVProgressHUD show];
}

- (void)refresh:(id)selector
{
    [self.refreshControl beginRefreshing];
    isRefresh = YES;
    [self _initStatus];
    [self.tableView reloadData];
    [self loadArticles:1];
    [self.refreshControl endRefreshing];
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

- (void)updateFavoriteTitle:(NSNotification *)notification
{
    AnimeDataManager *m = [AnimeDataManager sharedInstance];
    m.updatedFavorite = YES;
}

@end
