//
//  InitialAnimeListViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/03/30.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "InitialAnimeListViewController.h"
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
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = NO;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)registerTitles
{
    NSMutableArray *tids = [[AnimeDataManager sharedInstance] getFavorites];
    if (tids.count > 0) {
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"1つ以上選択してください" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
        [alert show];
    }
}

@end
