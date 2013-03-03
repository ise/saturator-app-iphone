//
//  Anime.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/02/28.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Anime : NSObject
@property (strong, nonatomic) NSString *tid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *started;
@property (strong, nonatomic) NSString *ended;
@property (readwrite) int startedTime;
@property (readwrite) int endedTime;
- (id)initWithDict:(NSDictionary*)dic;
@end
