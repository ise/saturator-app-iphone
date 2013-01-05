//
//  MainListAuthorViewCellController.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "BaseListViewCell.h"

@interface MainListAuthorViewCell : BaseListViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *feedName;
@property (strong, nonatomic) IBOutlet UILabel *displayDate;
@end

@interface MainListAuthorViewCellController : UIViewController
@property (strong, nonatomic) IBOutlet MainListAuthorViewCell *cell;

@end
