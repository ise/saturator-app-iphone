//
//  BaseListViewCell.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "BaseListViewCell.h"
#import "ArticleDataManager.h"

@implementation BaseListViewCell

@synthesize article;
@synthesize listView;
@synthesize defaultFavImage;
@synthesize activeFavImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setArticle:(Article *)a delegate:(id<ArticleDataManagerDelegate>)v
{
    self.listView = v;
    self.article = a;
}

@end
