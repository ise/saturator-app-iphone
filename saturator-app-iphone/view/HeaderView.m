//
//  HeaderView.m
//  CustomCellSample
//
//  Created by Hiroshi Hashiguchi on 11/07/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HeaderView.h"


@implementation HeaderView
@synthesize textLabel, imageView, activityIndicatorView;
@synthesize state = state_;

- (void)awakeFromNib
{
    self.state = HeaderViewStateHidden;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)_animateImageForHeadingUp:(BOOL)headingUp
{
    CGFloat startAngle = headingUp ? 0 : M_PI + 0.00001;
    CGFloat endAngle = headingUp ? M_PI + 0.00001 : 0;

    self.imageView.transform = CGAffineTransformMakeRotation(startAngle);           
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.imageView.transform =
                         CGAffineTransformMakeRotation(endAngle);
                         
                     }
                     completion:NULL
     ];
}

- (void)setState:(HeaderViewState)state
{
    switch (state) {
        case HeaderViewStateHidden:
            [self.activityIndicatorView stopAnimating];
            self.activityIndicatorView.hidden = YES;
            self.imageView.hidden = YES;
            break;
        case HeaderViewStatePullingDown:
            [self.activityIndicatorView stopAnimating];
            self.activityIndicatorView.hidden = YES;
            self.imageView.hidden = NO;
            self.textLabel.text = @"一覧を更新";
            if (state_ != HeaderViewStatePullingDown) {
                [self _animateImageForHeadingUp:NO];
            }
            break;
            
        case HeaderViewStateOveredThreshold:
            [self.activityIndicatorView stopAnimating];
            self.activityIndicatorView.hidden = YES;
            self.imageView.hidden = NO;
            self.textLabel.text = @"指をはなして更新";
            if (state_ == HeaderViewStatePullingDown) {
                [self _animateImageForHeadingUp:YES];
            }
            break;

        case HeaderViewStateStopping:
            self.activityIndicatorView.hidden = NO;
            [self.activityIndicatorView startAnimating];
            self.textLabel.text = @"更新中";
            self.imageView.hidden = YES;
            break;
    }

    state_ = state;
}


@end
