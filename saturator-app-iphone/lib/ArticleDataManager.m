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
    [database open];
    [database executeUpdate:sql];
    [database close];
    
    return self;
}

- (NSString *)urlencode:(NSString *)string
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)string,
                                                               NULL,
                                                               (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                               kCFStringEncodingUTF8);
}

//記事リストの更新
- (void)updateList:(id<ArticleDataManagerDelegate>) view Tids:(NSMutableArray *)tids Page:(int) page
{
    NSString *urlStr = @"http://localhost:9000/v1/article";
    urlStr = [NSString stringWithFormat:@"%@?page=%d", urlStr, page];
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
             return;
         }
         
         if (data) {
             NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             SBJsonParser *parser = [[SBJsonParser alloc] init];
             NSArray *resultList = [parser objectWithString:result];
             NSMutableArray *articles = [[NSMutableArray alloc] init];
             for (NSDictionary *dic in resultList) {
                 Article *a = [[Article alloc] initWithDict:dic];
                 [articles addObject:a];
             }
             [self _saveArticles:articles];
             [view buildView:articles];
         }
     }];
}

//記事をDBに保存する
- (void)_saveArticles:(NSMutableArray *)articles
{
    NSString *sql = @"insert into article (url,title,description,image,date,unixtime,feedName,feedIcon,feedUrl) VALUES (?,?,?,?,?,?,?,?,?)";
    [database open];
    [database beginTransaction];
    
    for (Article *a in articles) {
        NSLog(@"save article url=%@", a.url);
        [database executeUpdate: sql, a.url, a.title, a.description, a.image, a.date, [NSString stringWithFormat:@"%d", a.unixtime], a.feedName, a.feedIcon, a.feedUrl];
    }
    
    [database commit];
    [database close];
}

@end
