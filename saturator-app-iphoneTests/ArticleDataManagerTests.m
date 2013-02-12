//
//  ArticleDataManagerTests.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/17.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "ArticleDataManagerTests.h"
#import "ArticleDataManager.h"

@implementation ArticleDataManagerTests
- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSharedInstance
{
    ArticleDataManager *adm = [ArticleDataManager sharedInstance];
    STAssertNotNil(adm, @"インスタンス化失敗");
}

- (void)testGetArticles
{
    ArticleDataManager *adm = [ArticleDataManager sharedInstance];
    NSMutableArray *tids = [[NSMutableArray alloc] init];
    [tids addObject:@"853"];
    [tids addObject:@"2762"];
    [adm getArticles:tids];
    STAssertTrue(true, @"記事取得失敗");
}

@end
