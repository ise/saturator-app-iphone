//
//  MainListViewCellController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/04.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "MainListViewCellController.h"
#import "ArticleDataManager.h"
#import "JMImageCache.h"

@implementation MainListViewCell
- (void)setArticle:(Article *)article delegate:(id<ArticleDataManagerDelegate>)v
{
    [super setArticle:article delegate:v];
    self.title.text = article.title;
    [self.headImage setImageWithURL:[NSURL URLWithString:article.image] placeholder:[UIImage imageNamed:@"placeholder.png"]];

    if (article.bookmarked != 0) {
        //ブックマーク状態
        [self _bookmarkedStatus];
    } else {
        //未ブックマーク状態
        [self _unbookmarkedStatus];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    ArticleDataManager *m = [ArticleDataManager sharedInstance];
    if (touch.view.tag == self.defaultFavImage.tag) {
        //ブックマーク登録
        [self _bookmarkedStatus];
        self.article.bookmarked = [m addBookmark:self.article.url];
        //[self.listView updateArticleStatus:self.article];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.article forKey:@"article"];
        NSNotification *n = [NSNotification notificationWithName:@"UpdateArticleStatus" object:self userInfo:dic];
        [[NSNotificationCenter defaultCenter] postNotification:n];
    } else if (touch.view.tag == self.activeFavImage.tag) {
        //ブックマーク削除
        [self _unbookmarkedStatus];
        self.article.bookmarked = [m removeBookmark:self.article.url];
        //[self.listView updateArticleStatus:self.article];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.article forKey:@"article"];
        NSNotification *n = [NSNotification notificationWithName:@"UpdateArticleStatus" object:self userInfo:dic];
        [[NSNotificationCenter defaultCenter] postNotification:n];
    }else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)_bookmarkedStatus
{
    self.defaultFavImage.hidden = YES;
    self.activeFavImage.hidden = NO;
}

- (void)_unbookmarkedStatus
{
    self.defaultFavImage.hidden = NO;
    self.activeFavImage.hidden = YES;
}

@end


@implementation MainListViewCellController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
