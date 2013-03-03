//
//  Anime.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/02/28.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "Anime.h"

@implementation Anime
@synthesize tid;
@synthesize title;
@synthesize started;
@synthesize ended;
@synthesize startedTime;
@synthesize endedTime;

- (id)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    self.tid = [dic objectForKey:@"tid"];
    self.title = [dic objectForKey:@"title"];
    self.started = [dic objectForKey:@"started"];
    self.ended = [dic objectForKey:@"ended"];
    return self;
}


@end
