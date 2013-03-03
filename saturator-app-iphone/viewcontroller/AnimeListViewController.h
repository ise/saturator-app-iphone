//
//  AnimeListViewController.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimeDataManager.h"

@interface AnimeListViewController : UITableViewController <AnimeDataManagerDelegate>
@property (strong, nonatomic) NSMutableArray *animeList;
@property (strong, nonatomic) NSMutableArray *favorites;
@end
