//
//  InitialAnimeListViewController.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/03/30.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimeListViewController.h"

//@interface InitialAnimeListViewController : UITableViewController
@interface InitialAnimeListViewController : AnimeListViewController
@property (strong, nonatomic) IBOutlet UINavigationBar *naviBar;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@end
