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

#import "SVProgressHUD.h"

@implementation MainListViewController

@synthesize headerView;
@synthesize articleList;

int currentPage;
BOOL isRefresh = NO;

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
    self.hasNext = YES;
    [self.articleList removeAllObjects];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _setHeaderViewHidden:YES animated:NO];
    self.tableView.tableHeaderView = self.headerView;
    [self loadArticles:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    //navigationbar非表示に
    self.navigationController.navigationBarHidden = YES;
    //tabhbarは表示
    ((UITabBarController *)self.parentViewController.parentViewController).tabBar.hidden = NO;
    AnimeDataManager *m = [AnimeDataManager sharedInstance];
    if (m.updatedFavorite) {
        [self refresh:nil];
        m.updatedFavorite = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
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
    if (self.hasNext) {
        return count + 1;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= self.articleList.count) {
        //次を読み込むボタン
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseListViewCell *cell;
    if (indexPath.section >= self.articleList.count) {
        //次を読み込むボタン
        static NSString *CellIdentifier = @"MainListViewFooterCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            MainListViewFooterCellController *controller = [[MainListViewFooterCellController alloc] initWithNibName:@"MainListViewFooterCellController" bundle:nil];
            cell = (MainListViewFooterCell *)controller.view;
        }
        return cell;
    }
    
    Article *article = [self.articleList objectAtIndex:indexPath.section];
    if (indexPath.row % 2 == 0) {
        if ([article.image isEqualToString:@""]){ 
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
    if (indexPath.section >= self.articleList.count) {
        //次を読み込むボタン
        return 50;
    }
    if (indexPath.row % 2 == 0) {
        Article *article = [self.articleList objectAtIndex:indexPath.section];
        if ([article.image isEqualToString:@""]) {
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
    NSLog(@"didSelect %d", indexPath.section);
    if (indexPath.section >= self.articleList.count) {
        //次を読み込むボタン
        [self loadArticles:currentPage];
        return;
    }
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
}

- (void)buildView:(NSMutableArray *)articles
{
    [self.articleList addObjectsFromArray:articles];
    if (isRefresh) {
        isRefresh = NO;
        [self _taskFinished];
    }
    [SVProgressHUD dismiss];
    if (articles.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"記事が見つかりませんでした" delegate:self cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:alert repeats:NO];
        [alert show];
        self.hasNext = NO;
        
    }
    [self.tableView reloadData];
    
    currentPage++;
}

- (void)updateArticleStatus:(Article *)article
{
    NSLog(@"updateArticleStatus");
    for (int i=0; i<self.articleList.count; i++) {
        Article *a = [self.articleList objectAtIndex:i];
        if ([a.url isEqual:article.url]) {
            NSLog(@"found %@", a.url);
            [self.articleList replaceObjectAtIndex:i withObject:article];
            break;
        }
    }
}

//アラートを時限式で閉じる
- (void)performDismiss:(NSTimer *)theTimer
{
    UIAlertView *alertView = [theTimer userInfo];
    [alertView dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)loadArticles:(int)page
{
    NSLog(@"loadArticles page=%d", page);
    ArticleDataManager *manager = [ArticleDataManager sharedInstance];
    NSMutableArray *tids = [[AnimeDataManager sharedInstance] getFavorites];
    
    
    if (tids.count == 0) {
        [tids addObject:@"2825"];
    }
    
    
    [manager updateList:self Tids:tids Page:page];
    
    [SVProgressHUD show];
}

- (void)refresh:(id)selector
{
    [self _initStatus];
    [self loadArticles:1];
}

@end
