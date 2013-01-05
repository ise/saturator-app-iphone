//
//  Article.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/04.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *feedName;
@property (strong, nonatomic) NSString *feedIcon;
@property (strong, nonatomic) NSString *feedUrl;
@end
