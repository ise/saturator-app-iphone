//
//  ArticleDataManager.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/15.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "ArticleDataManager.h"
#import "Article.h"
#import "SBJson.h"

@implementation ArticleDataManager

@synthesize database;

NSString *HOST = @"localhost:9000";
int results = 20;
static ArticleDataManager *_sharedInstance;

+ (ArticleDataManager *)sharedInstance
{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ArticleDataManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathStr = [path objectAtIndex:0];
    database = [FMDatabase databaseWithPath:[dbPathStr stringByAppendingPathComponent:@"saturator.sqlite"]];
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS article ("
                        "url text primary key,"
                        "title text,"
                        "description text,"
                        "image text,"
                        "date text,"
                        "unixtime integer,"
                        "feedName text,"
                        "feedIcon text,"
                        "feedUrl text"
                    ");";
    
    NSString *relationSql = @"CREATE TABLE IF NOT EXISTS article_anime ("
                                "url text,"
                                "tid integer,"
                                "primary key (url, tid)"
                            ");";
    [database open];
    [database executeUpdate:sql];
    [database executeUpdate:relationSql];
    [database close];
    
    return self;
}

//記事リストの更新
- (void)updateList:(id<ArticleDataManagerDelegate>) view Tids:(NSMutableArray *)tids Page:(int) page
{
    int start = (page - 1) * results;
    NSString *urlStr = [NSString stringWithFormat: @"http://%@/v1/article", HOST];
    urlStr = [NSString stringWithFormat:@"%@?start=%d&results=%d", urlStr, start, results];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    NSString *param = [NSString stringWithFormat:@"[%@]", [tids componentsJoinedByString:@","]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error)
     {
         NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
         NSLog(@"StatusCode=%d",res.statusCode);
         if (error) {
             NSLog(@"error: %@", [error localizedDescription]);
             [view buildErrorView];
             return;
         }
         
         //APIからデータを取得
         if (data) {
             //データをDBに保存
             NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             SBJsonParser *parser = [[SBJsonParser alloc] init];
             NSArray *resultList = [parser objectWithString:result];
             NSMutableArray *list = [NSMutableArray array];
             for (NSDictionary *dic in resultList) {
                 Article *a = [[Article alloc] initWithAPIDict:dic];
                 [list addObject:a];
             }
             [self _saveArticles:list];
         }
         //DBからデータを取得し、表示処理を呼び出す
         NSMutableArray *articles = [self _loadArticles:tids start: start results: results];
         [view buildView:articles];
         
         //TODO:データが無い場合の処理
     }];
}

//記事をDBに保存する
- (void)_saveArticles:(NSMutableArray *)articles
{
    NSString *sql = @"insert into article (url,title,description,image,date,unixtime,feedName,feedIcon,feedUrl) values (?,?,?,?,?,?,?,?,?)";
    NSString *relationSql = @"insert into article_anime (url,tid) values (?,?)";
    [database open];
    [database beginTransaction];
    for (Article *a in articles) {
        NSLog(@"save article url=%@", a.url);
        //記事の保存
        [database executeUpdate: sql, a.url, a.title, a.description, a.image, a.date, [NSString stringWithFormat:@"%d", a.unixtime], a.feedName, a.feedIcon, a.feedUrl];
        for (NSString *tid in a.tids) {
            //記事とタイトルのrelationを保存
            [database executeUpdate: relationSql, a.url, tid];
        }
    }
    [database commit];
    [database close];
}

//記事をDBから読み込む
- (NSMutableArray *)_loadArticles:(NSMutableArray *)tids start:(int) start results:(int) results
{
    NSLog(@"_loadArticles %d,%d", start, results);
    
    NSMutableArray *articles = [NSMutableArray array];
    NSMutableArray *prepares = [NSMutableArray array];
    for (int i=0; i<tids.count; i++) {
        [prepares addObject:@"?"];
    }
    
    //お気に入り登録されたタイトルの記事のみ新着順で取得
    NSString *sql = [NSString stringWithFormat:@"select a.url,a.title,a.description,a.image,a.date,a.unixtime,a.feedName,a.feedIcon,a.feedUrl,group_concat(aa.tid) as tids from article a join article_anime aa on a.url=aa.url where tid in (%@) group by a.url order by unixtime desc limit %d,%d", [prepares componentsJoinedByString:@","], start, results];
    NSLog(@"_loadArticles sql=%@", sql);
    [database open];
    FMResultSet *result = [database executeQuery:sql withArgumentsInArray:tids];
    while ([result next]) {
        Article *a = [[Article alloc] initWithDBDict:[result resultDictionary]];
        [articles addObject:a];
    }
    [database close];
    return articles;
}

@end
