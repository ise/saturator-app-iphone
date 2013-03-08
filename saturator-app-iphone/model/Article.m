//
//  Article.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/04.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "Article.h"
#import "FMDatabase.h"

@implementation Article
@synthesize title;
@synthesize url;
@synthesize description;
@synthesize image;
@synthesize date;
@synthesize unixtime;
@synthesize feedName;
@synthesize feedIcon;
@synthesize feedUrl;
@synthesize clipped;

- (id)initWithAPIDict:(NSDictionary *)dic
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
    self.tids = [dic objectForKey:@"tid"];
    return self;
}

- (id)initWithDBDict:(NSDictionary *)dic
{
    self = [super init];
    self.title = [dic objectForKey:@"title"];
    self.url = [dic objectForKey:@"url"];
    self.description = [dic objectForKey:@"description"];
    self.image = [dic objectForKey:@"image"];
    self.unixtime = [[dic objectForKey:@"unixtime"] intValue];
    self.date = [self _displayDate:self.unixtime];
    self.feedName = [dic objectForKey:@"feedName"];
    self.feedUrl = [dic objectForKey:@"feedUrl"];
    self.feedIcon = [NSString stringWithFormat:@"http://favicon.qfor.info/f/%@", self.feedUrl];
    
    self.clipped = 0;
    NSNumber *tmp = [dic objectForKey:@"clipped"];
    if (![tmp isEqual:[NSNull null]]) {
        self.clipped = [tmp intValue];
    }

    
    self.tids = [[dic objectForKey:@"tids"] componentsSeparatedByString:@","];
    return self;
}

- (NSString *)_displayDate:(int)timestamp
{
    NSDate *now = [NSDate date];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)timestamp];
    NSTimeInterval passed = [now timeIntervalSinceDate:date];

    int min = passed / 60;
    if (min <= 1) {
        return @"1分前";
    }
    if (min < 60) {
        return [NSString stringWithFormat:@"%d分前", min];
    }
    int hour = min / 60;
    if (hour < 24) {
        return [NSString stringWithFormat:@"%d時間前", hour];
    }
    int day = hour / 24;
    return [NSString stringWithFormat:@"%d日前", day];
    /*
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *disp = [formatter stringFromDate:date];
    return disp;
     */
}


/*
- (CGFloat)heightForContents
{
    CGFloat padding = 0.0;
    return [self heightForTitle] + [self heightForImage] + padding;
}

- (CGFloat)heightForTitle
{
    CGFloat padding = 5.0;
    CGSize s = [self.title sizeWithFont:[UIFont fontWithName:@"Arial" size:16.0]];
    int line = (s.width / 260) + 1;
    return line * (s.height + 1.0) + padding;
}

- (CGFloat)heightForImage
{
    if ([self.image isEqualToString:@""]) {
        return 0.0;
    }
    CGFloat padding = 10.0;
    return 170.0 + padding;
}
*/


@end
