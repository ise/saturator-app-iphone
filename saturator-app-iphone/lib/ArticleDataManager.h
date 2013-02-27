//
//  ArticleDataManager.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/15.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@protocol ArticleDataManagerDelegate <NSObject>
- (void)buildView:(NSMutableArray *)articles;
@end

@interface ArticleDataManager : NSObject
@property (strong, nonatomic) FMDatabase *database;
+ (id)sharedInstance;
- (void)updateList:(id<ArticleDataManagerDelegate>) view Tids:(NSMutableArray *)tids Page:(int) page;
@end
