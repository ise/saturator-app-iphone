//
//  ConfigViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/03/17.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "ConfigViewController.h"
#import "ConfigDataManager.h"
#import "StaticFileViewController.h"

@implementation ConfigViewController

@synthesize configs;
@synthesize headers;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    }
    return self;
}

- (id)init
{
    self = [super init];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.headers = [NSMutableArray array];
    self.configs = [NSMutableArray array];
    
    //リストの表示要素設定
    [self.headers addObject:@"リストの表示要素"];
    [self.headers addObject:@"その他"];
    //TODO: MainListItemTypeと対応付け or 設定外出し
    NSMutableArray *cellConfig = [NSMutableArray array];
    [cellConfig addObject:@"タイトルと画像"];
    [cellConfig addObject:@"タイトルのみ"];
    //[cellConfig addObject:@"タイトルとモザイク画像"];
    [self.configs addObject:cellConfig];
    
    //ヘルプ、ライセンス
    NSMutableArray *cellHelp = [NSMutableArray array];
    [cellHelp addObject:@"ヘルプ"];
    [cellHelp addObject:@"ライセンス"];
    [self.configs addObject:cellHelp];
    
    
    //dummy
    /*
    [self.headers addObject:@"ダミー"];
    NSMutableArray *dummyConfig = [NSMutableArray array];
    [dummyConfig addObject:@"dummy1"];
    [dummyConfig addObject:@"dummy2"];
    [dummyConfig addObject:@"dummy3"];
    [self.configs addObject:dummyConfig];
     */
}

- (void)viewWillAppear:(BOOL)animated
{
    //navigationbar非表示に
    self.navigationController.navigationBarHidden = YES;
    //tabbarは表示
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
    return self.configs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.configs objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSMutableArray *conf = [self.configs objectAtIndex:indexPath.section];
    NSString *title = [conf objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    
    //リストの表示要素セクション
    if (indexPath.section == 0) {
        ConfigDataManager *m = [ConfigDataManager sharedInstance];
        int type = [m getMainListItemType];
        if (type == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.headers objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *v = [[UIView alloc] init];
	[v setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 5.0f, 300.0f, 35.0f)];
	lbl.backgroundColor = [UIColor clearColor];
    //#abafbc
    //67.1, 68.6, 73.7
    lbl.textColor = [UIColor colorWithRed:0.671 green:0.686 blue:0.737 alpha:1.0];
    lbl.text = [self.headers objectAtIndex:section];
	lbl.textAlignment = NSTextAlignmentLeft;
	lbl.font =  [UIFont boldSystemFontOfSize:17.0f];
	//lbl.shadowColor = [UIColor whiteColor];
	lbl.shadowOffset = CGSizeMake(0, 1);
	[v addSubview:lbl];
	return v;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ConfigDataManager *m = [ConfigDataManager sharedInstance];
        [m setMainListItemType:indexPath.row];
        [self.tableView reloadData];
        NSNotification *n = [NSNotification notificationWithName:@"UpdateItemType" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:n];
    } else if (indexPath.section == 1) {
        NSLog(@"run static file view controller");
        StaticFileViewController *staticFile = [[StaticFileViewController alloc] initWithNibName:@"StaticFileViewController" bundle:nil];
        staticFile.hidesBottomBarWhenPushed = YES;
        [staticFile setType:indexPath.row];
        [self.navigationController pushViewController:staticFile animated:YES];
    }
}

@end
