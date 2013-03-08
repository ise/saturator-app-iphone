//
//  BaseListViewCell.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "ArticleDataManager.h"

@interface BaseListViewCell : UITableViewCell
@property (strong, nonatomic) Article *article;
@property (strong, nonatomic) id<ArticleDataManagerDelegate> listView;
@property (strong, nonatomic) UIImageView *activeFavImage;
@property (strong, nonatomic) UIImageView *defaultFavImage;
- (void)setArticle:(Article *)a delegate:(id<ArticleDataManagerDelegate>)view;
@end
