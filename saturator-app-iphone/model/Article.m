//
//  Article.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/04.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "Article.h"

@implementation Article
@synthesize title = _title;
@synthesize url = _url;
@synthesize description = _description;
@synthesize image = _image;
@synthesize date = _date;
@synthesize unixtime = _unixtime;
@synthesize feedName = _feedName;
@synthesize feedIcon = _feedIcon;
@synthesize feedUrl = _feedUrl;


- (id)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    self.title = [dic objectForKey:@"title"];
    self.url = [dic objectForKey:@"id"];
    self.description = [dic objectForKey:@"description"];
    self.image = [dic objectForKey:@"image"];
    self.unixtime = [[dic objectForKey:@"timestamp"] intValue];
    self.date = [self _displayDate:self.unixtime];
    self.feedName = [dic objectForKey:@"feed_title"];
    self.feedUrl = [dic objectForKey:@"feed_link"];
    self.feedIcon = [NSString stringWithFormat:@"http://favicon.qfor.info/f/%@", self.feedUrl];
    return self;
}

- (NSString *)_displayDate:(int)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *disp = [formatter stringFromDate:date];
    return disp;
}

@end
