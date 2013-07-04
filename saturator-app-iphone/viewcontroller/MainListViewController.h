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
#import "EmptyView.h"
#import "FooterView.h"
#import "NADView.h"
#import "Anime.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#ifdef DEBUG
#define LINE() NSLog(@"%d",__LINE__)
#else
#define LINE() ;
#endif

@class HeaderView;
@class EmptyView;
@class FooterView;
@interface MainListViewController : UITableViewController <ArticleDataManagerDelegate,NADViewDelegate>

@property (strong, nonatomic) NSMutableArray *articleList;
@property (strong, nonatomic) Anime *targetAnime;
@property (nonatomic, retain) IBOutlet HeaderView* headerView;
@property (strong, nonatomic) IBOutlet EmptyView *emptyView;
@property (strong, nonatomic) IBOutlet FooterView *footerView;
@property (readwrite) BOOL hasNext;
@property (nonatomic, retain) NADView *nadView;

- (id)init;
- (id)initWithAnime:(Anime *)anime;
- (void)buildView:(NSMutableArray *)articles;
- (void)setAnime:(Anime *)anime;
@end
