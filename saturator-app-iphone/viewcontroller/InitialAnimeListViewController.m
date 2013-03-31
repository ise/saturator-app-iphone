//
//  InitialAnimeListViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/03/30.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "InitialAnimeListViewController.h"
//#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

@interface InitialAnimeListViewController ()

@end

@implementation InitialAnimeListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Titles";
    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(registerTitles)];
    self.navigationItem.rightBarButtonItem = b;
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = NO;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)registerTitles
{
    NSMutableArray *tids = [[AnimeDataManager sharedInstance] getFavorites];
    if (tids.count > 0) {
        NSLog(@"registerTitles to MainListView");
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"1つ以上選択してください" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
        [alert show];
    }
}

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
*/
@end
