//
//  MainListViewFooterCellController.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/02/25.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListViewCell.h"

@interface MainListViewFooterCell : BaseListViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;

@end

@interface MainListViewFooterCellController : UIViewController
@property (strong, nonatomic) IBOutlet MainListViewFooterCell *cell;

@end
