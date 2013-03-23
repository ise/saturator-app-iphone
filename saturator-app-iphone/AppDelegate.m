//
//  AppDelegate.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/04.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize tabBarController;
@synthesize mainListViewController;
@synthesize animeListViewController;
@synthesize bookmarkListViewController;
@synthesize recommendViewController;
@synthesize configViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.mainListViewController = [[MainListViewController alloc] init];
    self.animeListViewController = [[AnimeListViewController alloc] init];
    self.bookmarkListViewController = [[BookmarkListViewController alloc] init];
    self.recommendViewController = [[RecommendViewController alloc] init];
    self.configViewController = [[ConfigViewController alloc] init];
    UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:self.mainListViewController];
    //mainNavi.navigationBarHidden = YES;
    mainNavi.navigationBar.tintColor = [UIColor blackColor];
    UINavigationController *animeNavi = [[UINavigationController alloc] initWithRootViewController:self.animeListViewController];
    animeNavi.navigationBar.tintColor = [UIColor blackColor];
    UINavigationController *favNavi = [[UINavigationController alloc] initWithRootViewController:self.bookmarkListViewController];
    favNavi.navigationBar.tintColor = [UIColor blackColor];
    
    //TODO:tabbarのデザイン（アイコン？）修正
    self.tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    NSArray *controllers = [[NSArray alloc] initWithObjects:mainNavi,animeNavi,favNavi,self.recommendViewController,self.configViewController,nil];
    [self.tabBarController setViewControllers:controllers];
    
    int i = 0;
    NSArray *tabs = [NSArray arrayWithObjects:
                       [NSArray arrayWithObjects:@"home", @"home.png", nil],
                       [NSArray arrayWithObjects:@"anime", @"list.png", nil],
                       [NSArray arrayWithObjects:@"bookmark", @"bookmark.png", nil],
                       [NSArray arrayWithObjects:@"recommend", @"recommend.png", nil],
                       [NSArray arrayWithObjects:@"config", @"config.png", nil],
                       nil];
    for (UITabBarItem *item in self.tabBarController.tabBar.items) {
        //タブのラベル設定
        NSArray *val = [tabs objectAtIndex:i];
        [item setTitle:[val objectAtIndex:0]];
        NSString *icon = [val objectAtIndex:1];
        UIImage *selectedImage = [UIImage imageNamed:icon];
        UIImage *unselectedImage = [UIImage imageNamed:icon];
        //タブの画像を設定
        [item setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
        //タブの文字色を設定(選択前)
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
        //タブの文字色を設定(選択中)
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.99 green:0.0 blue:0.789 alpha:1.0], UITextAttributeTextColor,nil] forState:UIControlStateSelected];
        i++;
    }
    
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
