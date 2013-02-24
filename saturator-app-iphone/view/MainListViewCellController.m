//
//  MainListViewCellController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/04.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "MainListViewCellController.h"
#import "JMImageCache.h"

@implementation MainListViewCell
- (void)setArticle:(Article *)article
{
    self.title.text = article.title;
    //NSData *d = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:article.image]];
    [self.headImage setImageWithURL:[NSURL URLWithString:article.image] placeholder:[UIImage imageNamed:@"placeholder.png"]];
    //self.headImage.image = [[UIImage alloc] initWithData:d];
    //self.headImage.image = [[JMImageCache sharedCache] imageForURL:[NSURL URLWithString:article.image] delegate:self];
}
@end

/*
@interface MainListViewCellController ()

@end
*/

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
