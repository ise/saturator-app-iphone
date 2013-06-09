//
//  ArticleDataManager.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/15.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "ArticleDataManager.h"
#import "SBJson.h"

@implementation ArticleDataManager

@synthesize database;

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
                        "feedUrl text,"
                        "bookmarked integer"
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
- (void)updateList:(id<ArticleDataManagerDelegate>) view Tids:(NSMutableArray *)tids Page:(int) page Retry:(int) retry
{
    @try {
        int start = (page - 1) * results;
        NSString *urlStr = [NSString stringWithFormat: @"http://%@/v1/article", [BaseConfig API_HOST]];
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
             BOOL isError = NO;
             //NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
             //NSLog(@"StatusCode=%d",res.statusCode);
             if (error) {
                 if (retry > 0) {
                     //リトライ開始
                     //リトライ処理完了後自分はreturnで抜ける
                     [self updateList:view Tids:tids Page:page Retry:retry-1];
                     return;
                 } else {
                     isError = YES;
                 }
             }
             
             //APIからデータを取得
             if (data) {
                 //データをDBに保存
                 NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 SBJsonParser *parser = [[SBJsonParser alloc] init];
                 NSObject *resultList = [parser objectWithString:result];
                 
                 if ([resultList isKindOfClass:[NSDictionary class]]) {
                     //resultListが期待した型で無い場合はリトライ
                     if (retry > 0) {
                         [self updateList:view Tids:tids Page:page Retry:retry-1];
                         return;
                     } else {
                         isError = YES;
                     }
                 } else {
                     //resultListが期待した型である場合は保存処理へ
                     //データをクリア
                     if (page == 1) {
                         //NSLog(@"clear database");
                         NSString *delSql = @"delete from article where bookmarked is null";
                         NSString *delRelSql = @"delete from article_anime aa join article a on a.url=aa.url where a.bookmarked is null";
                         [database open];
                         [database executeUpdate:delSql];
                         [database executeUpdate:delRelSql];
                         [database close];
                     }
                     
                     NSArray *array = (NSArray *)resultList;
                     NSMutableArray *list = [NSMutableArray array];
                     for (NSDictionary *dic in array) {
                         Article *a = [[Article alloc] initWithAPIDict:dic];
                         [list addObject:a];
                     }
                     [self _saveArticles:list];
                 }
             }
             //DBからデータを取得し、表示処理を呼び出す
             NSMutableArray *articles = [self _loadArticles:tids start: start results: results];
             //NSLog(@"loadArticles");
             
             
             //NSLog(@"isError=%d", isError);
             //記事が取得できず、かつエラーである場合はエラー用画面を表示する
             if (articles.count > 0 || !isError) {
                 [view buildView:articles];
             } else {
                 [view buildErrorView];
             }
         }];
    }
    @catch (NSException *exception) {
        //NSLog(@"exception: %@, %@", exception.name, exception.reason);
        [view buildErrorView];
        return;
    }
    @finally {
    }
}

//ブックマーク記事の非同期読み込み
- (void)loadBookmarks:(id<ArticleDataManagerDelegate>)view
{
    NSMutableArray *articles = [NSMutableArray array];
    
    //ブックマークされた記事のみブックマーク日時の降順で取得
    NSString *sql = [NSString stringWithFormat:@"select a.url,a.title,a.description,a.image,a.date,a.unixtime,a.feedName,a.feedIcon,a.feedUrl,a.bookmarked,group_concat(aa.tid) as tids from article a join article_anime aa on a.url=aa.url where a.bookmarked is not null group by a.url order by a.bookmarked desc"];
    [database open];
    FMResultSet *result = [database executeQuery:sql];
    while ([result next]) {
        Article *a = [[Article alloc] initWithDBDict:[result resultDictionary]];
        [articles addObject:a];
    }
    [database close];
    
    [view buildView:articles];
}

//記事をDBに保存する
- (void)_saveArticles:(NSMutableArray *)articles
{
    NSString *sql = @"insert into article (url,title,description,image,date,unixtime,feedName,feedIcon,feedUrl) values (?,?,?,?,?,?,?,?,?)";
    NSString *updateSql = @"update article set title=?,description=?,image=?,date=?,unixtime=?,feedName=?,feedIcon=?,feedUrl=? where url=?";
    NSString *relationSql = @"replace into article_anime (url,tid) values (?,?)";
    [database open];
    [database beginTransaction];
    for (Article *a in articles) {
        //NSLog(@"save article url=%@", a.url);
        //記事の保存
        FMResultSet *r = [database executeQuery:@"select url from article where url=?", a.url];
        if (![r next]) {
            //新規記事はinsert
            [database executeUpdate: sql, a.url, a.title, a.description, a.image, a.date, [NSString stringWithFormat:@"%d", a.unixtime], a.feedName, a.feedIcon, a.feedUrl];
        } else {
            //既存記事はupdate
            [database executeUpdate: updateSql, a.title, a.description, a.image, a.date, [NSString stringWithFormat:@"%d", a.unixtime], a.feedName, a.feedIcon, a.feedUrl, a.url];
        }
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
    NSMutableArray *articles = [NSMutableArray array];
    NSMutableArray *prepares = [NSMutableArray array];
    for (int i=0; i<tids.count; i++) {
        [prepares addObject:@"?"];
    }
    
    //お気に入り登録されたタイトルの記事のみ新着順で取得
    NSString *sql = [NSString stringWithFormat:@"select a.url,a.title,a.description,a.image,a.date,a.unixtime,a.feedName,a.feedIcon,a.feedUrl,a.bookmarked,group_concat(aa.tid) as tids from article a join article_anime aa on a.url=aa.url where tid in (%@) group by a.url order by unixtime desc limit %d,%d", [prepares componentsJoinedByString:@","], start, results];
    [database open];
    FMResultSet *result = [database executeQuery:sql withArgumentsInArray:tids];
    while ([result next]) {
        Article *a = [[Article alloc] initWithDBDict:[result resultDictionary]];
        [articles addObject:a];
    }
    [database close];
    return articles;
}

//ブックマーク（あとで読む）を保存
- (int)addBookmark:(NSString *)url
{
    int now = (int)[[NSDate date] timeIntervalSince1970];
    NSString *sql = @"update article set bookmarked=? where url=?";
    [database open];
    [database beginTransaction];
    [database executeUpdate: sql, [NSString stringWithFormat:@"%d", now], url];
    [database commit];
    [database close];
    return now;
}

//ブックマーク（あとで読む）を削除
- (int)removeBookmark:(NSString *)url
{
    NSString *sql = @"update article set bookmarked=null where url=?";
    [database open];
    [database beginTransaction];
    [database executeUpdate: sql, url];
    [database commit];
    [database close];
    return 0;
}

- (BOOL)isBookmarked:(NSString *)url
{
    //お気に入り登録されたタイトルの記事のみ新着順で取得
    NSString *sql = @"select url from article where bookmarked is not null and url = ?";
    [database open];
    FMResultSet *result = [database executeQuery:sql, url];
    BOOL exist = NO;
    while ([result next]) {
        exist = YES;
        break;
    }
    [database close];
    return exist;
}

@end
