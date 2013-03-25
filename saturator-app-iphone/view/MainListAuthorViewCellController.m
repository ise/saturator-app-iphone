//
//  MainListAuthorViewCellController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "MainListAuthorViewCellController.h"
#import "JMImageCache.h"

@implementation MainListAuthorViewCell
- (void)setArticle:(Article *)article
{
    self.feedName.text = article.feedName;
    //[self.iconImage setImageWithURL:[NSURL URLWithString:article.feedIcon] placeholder:[UIImage imageNamed:@"placeholder.png"]];
    self.displayDate.text = article.date;
}
@end

@implementation MainListAuthorViewCellController

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
