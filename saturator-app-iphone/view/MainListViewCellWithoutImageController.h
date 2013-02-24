//
//  MainListViewCellWithoutImageController.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/02/24.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "BaseListViewCell.h"

@interface MainListViewCellWithoutImage : BaseListViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@end

@interface MainListViewCellWithoutImageController : UIViewController
@property (strong, nonatomic) IBOutlet MainListViewCellWithoutImage *cell;

@end
