//
//  AppDelegate.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/04.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize tabBarController = _tabBarController;
@synthesize mainListViewController = _mainListViewController;
@synthesize animeListViewController = _animeListViewController;
@synthesize favoriteListViewController = _favoriteListViewController;
@synthesize configViewController = _configViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.mainListViewController = [[MainListViewController alloc] init];
    self.animeListViewController = [[AnimeListViewController alloc] init];
    self.favoriteListViewController = [[FavoriteListViewController alloc] init];
    self.configViewController = [[ConfigViewController alloc] init];
    UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:self.mainListViewController];
    //mainNavi.navigationBarHidden = YES;
    mainNavi.navigationBar.tintColor = [UIColor blackColor];
    UINavigationController *animeNavi = [[UINavigationController alloc] initWithRootViewController:self.animeListViewController];
    animeNavi.navigationBar.tintColor = [UIColor blackColor];
    UINavigationController *favNavi = [[UINavigationController alloc] initWithRootViewController:self.favoriteListViewController];
    favNavi.navigationBar.tintColor = [UIColor blackColor];
    
    //TODO:tabbarのデザイン（アイコン？）修正
    self.tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    NSArray *controllers = [[NSArray alloc] initWithObjects:mainNavi,animeNavi,favNavi,self.configViewController,nil];
    [self.tabBarController setViewControllers:controllers];
    
    for (UITabBarItem *item in self.tabBarController.tabBar.items) {
        //UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:0];
        UIImage *selectedImage = [UIImage imageNamed:@"home.png"];
        UIImage *unselectedImage = [UIImage imageNamed:@"home.png"];
        //タブバー選択・非選択時の画像を設定
        [item setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
        //タブバーの文字色を設定(選択前)
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
        //タブバーの文字色を設定(選択中)
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.99 green:0.0 blue:0.789 alpha:1.0], UITextAttributeTextColor,nil] forState:UIControlStateSelected];
        //[item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateSelected];
        [item setTitle:@"HOME"];
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
