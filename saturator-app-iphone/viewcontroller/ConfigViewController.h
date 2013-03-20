//
//  ConfigViewController.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/03/17.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *configs;
@property (strong, nonatomic) NSMutableArray *headers;
- (id)init;
@end
