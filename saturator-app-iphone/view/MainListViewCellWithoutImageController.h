//
//  MainListViewCellWithoutImageController.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/02/24.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "MainListViewCellController.h"

@interface MainListViewCellWithoutImage : MainListViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *defaultFavImage;
@property (strong, nonatomic) IBOutlet UIImageView *activeFavImage;
@end

@interface MainListViewCellWithoutImageController : UIViewController
@property (strong, nonatomic) IBOutlet MainListViewCellWithoutImage *cell;

@end
