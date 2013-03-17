//
//  FooterView.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/03/17.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleDataManager.h"

@interface FooterView : UIView
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) id<ArticleDataManagerDelegate>listView;
- (void)setListView:(id<ArticleDataManagerDelegate>)view;
@end
