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

    if (article.clipped != 0) {
        //クリップ状態
        NSLog(@"%@ has clipped status", article.url);
        [self _clippedStatus];
    } else {
        //未クリップ状態
        [self _unclippedStatus];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    ArticleDataManager *m = [ArticleDataManager sharedInstance];
    if (touch.view.tag == self.defaultFavImage.tag) {
        //クリップ登録
        [self _clippedStatus];
        self.article.clipped = [m addClip:self.article.url];
        NSLog(@"%@ is clipped", self.article.url);
        [self.listView updateArticleStatus:self.article];
    } else if (touch.view.tag == self.activeFavImage.tag) {
        //クリップ削除
        [self _unclippedStatus];
        self.article.clipped = [m removeClip:self.article.url];
        NSLog(@"%@ is unclipped", self.article.url);
        [self.listView updateArticleStatus:self.article];
    }else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)_clippedStatus
{
    self.defaultFavImage.hidden = YES;
    self.activeFavImage.hidden = NO;
}

- (void)_unclippedStatus
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
