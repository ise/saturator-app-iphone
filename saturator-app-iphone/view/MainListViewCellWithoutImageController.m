//
//  MainListViewCellWithoutImageController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/02/24.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "MainListViewCellWithoutImageController.h"

@implementation MainListViewCellWithoutImage
- (void)setArticle:(Article *)article
{
    self.title.text = article.title;
}
@end

/*
@interface MainListViewCellWithoutImageController ()

@end
*/

@implementation MainListViewCellWithoutImageController

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
