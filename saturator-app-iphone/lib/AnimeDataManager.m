//
//  AnimeDataManager.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/02/28.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "AnimeDataManager.h"
#import "SBJson.h"
#import "Anime.h"

@implementation AnimeDataManager

@synthesize database;
@synthesize updatedFavorite;

static AnimeDataManager *_sharedInstance;

+ (AnimeDataManager *)sharedInstance
{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[AnimeDataManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathStr = [path objectAtIndex:0];
    database = [FMDatabase databaseWithPath:[dbPathStr stringByAppendingPathComponent:@"saturator.sqlite"]];
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS anime ("
    "tid integer primary key,"
    "title text,"
    "image text,"
    "started integer,"
    "ended integer"
    ");";
    NSString *favSql = @"CREATE TABLE IF NOT EXISTS favorite ("
    "tid integer primary key,"
    "created integer"
    ");";
    [database open];
    [database executeUpdate:sql];
    [database executeUpdate:favSql];
    [database close];
    
    self.updatedFavorite = NO;
    
    return self;
}

//アニメリストの更新
- (void)updateList:(id<AnimeDataManagerDelegate>) view Retry:(int)retry
{
    NSString *urlStr = [NSString stringWithFormat: @"http://%@/v1/anime", [BaseConfig API_HOST]];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error)
     {
         NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
         NSLog(@"StatusCode=%d",res.statusCode);
         if (error) {
             if (retry > 0) {
                 [self updateList:view Retry:retry-1];
             } else {
                 [view buildErrorView];
                 return;
             }
         }
         
         //APIからデータ取得
         if (data) {
             //DBに保存
             NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             SBJsonParser *parser = [[SBJsonParser alloc] init];
             NSArray *resultList = [parser objectWithString:result];
             if ([resultList isKindOfClass:[NSDictionary class]]) {
                 if (retry > 0) {
                     [self updateList:view Retry:retry-1];
                 } else {
                     [view buildErrorView];
                     return;
                 }
             }
             
             NSMutableArray *list = [[NSMutableArray alloc] init];
             for (NSDictionary *dic in resultList) {
                 Anime *a = [[Anime alloc] initWithAPIDict:dic];
                 [list addObject:a];
             }
             [self _saveAnimes:list];
         }
         
         //DBからデータ取得
         NSMutableArray *animes = [self _loadAnimes];
         [view buildView:animes];
     }];
}

//タイトルをDBから取得する
- (NSMutableArray *)_loadAnimes
{
    NSMutableArray *animes = [NSMutableArray array];
    NSString *sql = @"select * from anime order by tid desc";
    [database open];
    FMResultSet *results = [database executeQuery:sql];
    while ([results next]) {
        Anime *a = [[Anime alloc] initWithDBDict:[results resultDictionary]];
        [animes addObject:a];
    }
    [database close];
    return animes;
}

//タイトルをDBに保存する
- (void)_saveAnimes:(NSMutableArray *)animes
{
    NSString *sql = @"insert into anime (tid,title,image,started,ended) VALUES (?,?,?,?,?)";
    [database open];
    [database beginTransaction];
    
    for (Anime *a in animes) {
        //NSLog(@"save anime title=%@", a.title);
        [database executeUpdate: sql, a.tid, a.title, a.image, 0, 0];
    }
    
    [database commit];
    [database close];
}

//お気に入り一覧を取得
- (NSMutableArray *)getFavorites
{
    NSMutableArray *favorites = [NSMutableArray array];
    NSString *sql = @"select * from favorite";
    [database open];
    FMResultSet *results = [database executeQuery:sql];
    while ([results next]) {
        NSString *tid = [results stringForColumn:@"tid"];
        [favorites addObject:tid];
    }
    [database close];
    return favorites;
}

//お気に入りを保存
- (void)setFavorites:(NSMutableArray *)favorites
{
    NSString *sql = @"insert into favorite (tid,created) values (?,?)";
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    [database open];
    [database executeUpdate:@"delete from favorite"];
    [database beginTransaction];
    for (NSString *key in [favorites objectEnumerator]) {
        //NSLog(@"save favorite tid=%@", key);
        [database executeUpdate: sql, key, [NSString stringWithFormat:@"%d",(int)now]];
    }
    [database commit];
    [database close];
    
    self.updatedFavorite = YES;
}

@end
