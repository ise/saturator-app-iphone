//
//  DataManager.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/02/28.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseConfig.h"

@interface DataManager : NSObject
- (NSString *)urlencode:(NSString *)string;
@end
