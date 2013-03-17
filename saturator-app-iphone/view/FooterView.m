//
//  FooterView.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/03/17.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView

@synthesize listView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setListView:(id<ArticleDataManagerDelegate>)view
{
    listView = view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.listView loadNextPosts];
}

@end
