//
//  AppDelegate.h
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/04.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainListViewController.h"
#import "AnimeListViewController.h"
#import "ClipListViewController.h"
#import "RecommendViewController.h"
#import "ConfigViewController.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) MainListViewController *mainListViewController;
@property (strong, nonatomic) AnimeListViewController *animeListViewController;
@property (strong, nonatomic) ClipListViewController *clipListViewController;
@property (strong, nonatomic) RecommendViewController *recommendViewController;
@property (strong, nonatomic) ConfigViewController *configViewController;

@end
