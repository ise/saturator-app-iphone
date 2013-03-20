//
//  ConfigDataManager.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/03/20.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, MainListItemType)
{
    MainListItemTypeAll = 0,
    MainListItemTypeTitle,
    MainListItemTypeMosaic
};

@interface ConfigDataManager : NSObject
@property (strong, nonatomic) NSUserDefaults *userDefaults;
+ (ConfigDataManager *)sharedInstance;
- (void)setMainListItemType:(int)type;
- (int)getMainListItemType;
@end
