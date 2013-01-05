//
//  MainListViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/04.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "MainListViewController.h"
#import "MainListViewCellController.h"
#import "MainListAuthorViewCellController.h"
#import "Article.h"
#import "BaseListViewCell.h"

/*
@interface MainListViewController ()

@end
*/


@implementation MainListViewController

@synthesize articleList = _articleList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.articleList = [[NSMutableArray alloc] init];
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
        self.tableView.allowsSelection = NO;
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
    
    [self.articleList addObject:[self _getArticle:1]];
    [self.articleList addObject:[self _getArticle:2]];
    [self.articleList addObject:[self _getArticle:3]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.articleList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseListViewCell *cell;
    if (indexPath.row % 2 == 0) {
        static NSString *CellIdentifier = @"MainListViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            MainListViewCellController *controller = [[MainListViewCellController alloc] initWithNibName:@"MainListViewCellController" bundle:nil];
            cell = (MainListViewCell *)controller.view;
        }
    } else {
        static NSString *CellIdentifier = @"MainListAuthorViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            MainListAuthorViewCellController *controller = [[MainListAuthorViewCellController alloc] initWithNibName:@"MainListAuthorViewCellController" bundle:nil];
            cell = (MainListAuthorViewCell *)controller.view;
        }
    }
    Article *article = [self.articleList objectAtIndex:indexPath.section];
    [cell setArticle:article];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO:セルの内容に合わせたサイズを返すように修正
    if (indexPath.row % 2 == 0) {
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
    //TODO:選択されたら、詳細画面へ遷移させる
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
