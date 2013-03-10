//
//  MainListViewController.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/04.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ArticleDataManager.h"
#import "HeaderView.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#ifdef DEBUG
#define LINE() NSLog(@"%d",__LINE__)
#else
#define LINE() ;
#endif

@class HeaderView;
@interface MainListViewController : UITableViewController <ArticleDataManagerDelegate>

@property (strong, nonatomic) NSMutableArray *articleList;
@property (nonatomic, retain) IBOutlet HeaderView* headerView;

- (void)buildView:(NSMutableArray *)articles;
@end
