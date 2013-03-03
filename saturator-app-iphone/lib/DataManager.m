//
//  DataManager.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/02/28.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
- (NSString *)urlencode:(NSString *)string
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (CFStringRef)string,
                                                                        NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
}
@end
