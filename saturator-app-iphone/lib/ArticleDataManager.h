//
//  ArticleDataManager.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/15.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DataManager.h"
#import "Article.h"

@protocol ArticleDataManagerDelegate <NSObject>
- (void)buildView:(NSMutableArray *)articles;
- (void)buildErrorView;
- (void)updateArticleStatus:(Article *)article;
- (void)loadNextPosts;
@end

@interface ArticleDataManager : DataManager
@property (strong, nonatomic) FMDatabase *database;
+ (id)sharedInstance;
- (void)updateList:(id<ArticleDataManagerDelegate>) view Tids:(NSMutableArray *)tids Page:(int) page;
- (void)loadClips:(id<ArticleDataManagerDelegate>) view;
- (int)addClip:(NSString *)url;
- (int)removeClip:(NSString *)url;
@end
