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

/*
@interface MainListViewController ()

@end
*/


@implementation MainListViewController

@synthesize articleList = _articleList;

int currentPage = 1;
BOOL hasNext = YES;
BOOL isInit = YES;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
        self.navigationItem.rightBarButtonItem = reloadButton;
        self.articleList = [[NSMutableArray alloc] init];
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
        //self.tableView.allowsSelection = NO;
    }
    
    return self;
}

- (Article*)_getArticle:(int)index
{
    Article *a1 = [Article alloc];
    a1.title = [NSString stringWithFormat:@"【たまこまーけっと】2013年アニメ業界予測！「まどか☆マギカ」から続く、オリジナルアニメヒットの“流れ”を守れるか %d", index];
    a1.url = @"http://yaraon.blog109.fc2.com/blog-entry-13803.html";
    a1.description = @"";
    a1.date = @"2時間前";
    a1.image = @"http://blog-imgs-51.fc2.com/y/a/r/yaraon/hwchannel_20130104_2238804_0-enlarges.jpg";
    a1.feedIcon = @"http://yaraon.blog109.fc2.com/favicon.ico";
    a1.feedName = @"やらおん!";
    a1.feedUrl = @"http://yaraon.blog109.fc2.com/";
    return a1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadArticles:1];
}

- (void)viewDidAppear:(BOOL)animated
{
    ((UITabBarController *)self.parentViewController.parentViewController).tabBar.hidden = NO;
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
    if (hasNext) {
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
    [cell setArticle:article];
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
            return 100;
        }
        return 260;
    } else {
        return 60;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    [SVProgressHUD dismiss];
    [alert show];
}

- (void)buildView:(NSMutableArray *)articles
{
    if (isInit) {
        //初期化
        [self.articleList removeAllObjects];
        currentPage = 1;
        isInit = NO;
        hasNext = YES;
    }
    [self.articleList addObjectsFromArray:articles];
    [SVProgressHUD dismiss];
    if (articles.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"これ以前の記事が見つかりませんでした" delegate:self cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:alert repeats:NO];
        [alert show];
        hasNext = NO;
        
    }
    [self.tableView reloadData];
    
    currentPage++;
}

- (void)performDismiss:(NSTimer *)theTimer
{
    UIAlertView *alertView = [theTimer userInfo];
    [alertView dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)loadArticles:(int) page
{
    ArticleDataManager *manager = [ArticleDataManager sharedInstance];
    NSMutableArray *tids = [[AnimeDataManager sharedInstance] getFavorites];
    [manager updateList:self Tids:tids Page:page];
    
    [SVProgressHUD show];
}

- (void)refresh:(id)selector
{
    isInit = YES;
    [self loadArticles:1];
}

@end
