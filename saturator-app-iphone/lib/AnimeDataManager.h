//
//  AnimeDataManager.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/02/28.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DataManager.h"

@protocol AnimeDataManagerDelegate <NSObject>
- (void)buildView:(NSMutableArray *)animes;
- (void)buildErrorView;
@end

@interface AnimeDataManager : DataManager
@property (strong, nonatomic) FMDatabase *database;
@property (readwrite) BOOL updatedFavorite;
+ (id)sharedInstance;
- (void)updateList:(id<AnimeDataManagerDelegate>) view Retry:(int) retry;
- (NSMutableArray *)getFavorites;
- (void)setFavorites:(NSMutableArray *)favorites;
//- (void)clearAnimes;
//- (void)clearFavorite;
@end
