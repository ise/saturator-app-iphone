//
//  AnimeListViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "AnimeListViewController.h"
#import "Anime.h"
#import "SVProgressHUD.h"

@implementation AnimeListViewController

@synthesize animeList = _animeList;
@synthesize favorites = _favorites;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.animeList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super setEditing:YES animated:YES];
    self.navigationController.navigationBarHidden = YES;
    
    //リロードボタンを付ける
    UIBarButtonItem *reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(_loadAnimeList)];
    self.navigationItem.leftBarButtonItem = reload;
    
    [self _loadAnimeList];
}

- (void)viewWillAppear:(BOOL)animated
{
    AnimeDataManager *manager = [AnimeDataManager sharedInstance];
    self.favorites = [manager getFavorites];
    [self.tableView reloadData];
}

- (void)_loadAnimeList
{
    AnimeDataManager *manager = [AnimeDataManager sharedInstance];
    self.favorites = [manager getFavorites];
    [manager updateList:self Retry:10];
    [SVProgressHUD show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.animeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Anime *a = [self.animeList objectAtIndex:indexPath.section];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.5;
    cell.textLabel.text = a.title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.animeList.count == 0) {
        return nil;
    }
    
    
    Anime *a = [self.animeList objectAtIndex:indexPath.section];
    if ([self.favorites containsObject:a.tid]) {
        return UITableViewCellEditingStyleDelete;
    }
    /*
    for (int i=0; i<self.favorites.count; i++) {
        NSString *f = [[self.favorites objectAtIndex:i] stringValue];
        if ([f isEqualToString:a.tid]) {
            return UITableViewCellEditingStyleDelete;
        }
    }
     */
    return UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Anime *a = [self.animeList objectAtIndex:indexPath.section];
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self.favorites addObject:a.tid];
    } else if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.favorites removeObject:a.tid];
    }
    AnimeDataManager *m = [AnimeDataManager sharedInstance];
    [m setFavorites:self.favorites];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    NSNotification *n = [NSNotification notificationWithName:@"UpdateFavoriteTitle" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)buildErrorView
{
    //UIAlertView *alert = [[UIAlertView alloc] init];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"データを取得できませんでした" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
    [SVProgressHUD dismiss];
    [alert show];
}

- (void)buildView:(NSMutableArray *)animes
{
    self.animeList = animes;
    [SVProgressHUD dismiss];
    if (animes.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"タイトルが取得できませんでした" delegate:self cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:alert repeats:NO];
        [alert show];
    }
    [self.tableView reloadData];
}

//アラートを時限式で閉じる
- (void)performDismiss:(NSTimer *)theTimer
{
    UIAlertView *alertView = [theTimer userInfo];
    [alertView dismissWithClickedButtonIndex:0 animated:NO];
}

@end
