//
//  ConfigDataManager.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/03/20.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "ConfigDataManager.h"

@implementation ConfigDataManager

@synthesize userDefaults;

static ConfigDataManager *_sharedInstance;

+ (ConfigDataManager *)sharedInstance
{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ConfigDataManager alloc] init];
        _sharedInstance.userDefaults = [NSUserDefaults standardUserDefaults];
    });
    return _sharedInstance;
}


- (void)setMainListItemType:(int)type
{
    [self.userDefaults setInteger:type forKey:@"MainListItemType"];
    [self.userDefaults synchronize];
}

- (int)getMainListItemType
{
    return [self.userDefaults integerForKey:@"MainListItemType"];
}

@end
