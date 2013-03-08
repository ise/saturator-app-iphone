//
//  MainListViewCellController.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/04.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Article.h"
#import "BaseListViewCell.h"

@interface MainListViewCell : BaseListViewCell
@property (strong, nonatomic) IBOutlet UIImageView *activeFavImage;
@property (strong, nonatomic) IBOutlet UIImageView *defaultFavImage;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *title;
@end

@interface MainListViewCellController : UIViewController
@property (strong, nonatomic) IBOutlet MainListViewCell *cell;
@end
