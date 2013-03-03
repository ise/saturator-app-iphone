//
//  AnimeListViewController.m
//  saturator-app-iphone
//
//  Created by Masaaki Takeuchi on 2013/01/05.
//  Copyright (c) 2013年 Masaaki Takeuchi. All rights reserved.
//

#import "AnimeListViewController.h"
#import "Anime.h"

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
    AnimeDataManager *manager = [AnimeDataManager sharedInstance];
    NSMutableArray *fav = [[NSMutableArray alloc] init];
    [fav addObject:@"2709"];
    [fav addObject:@"2716"];
    [fav addObject:@"2732"];
    [fav addObject:@"2738"];
    [fav addObject:@"2861"];
    [fav addObject:@"853"];
    [manager setFavorites:fav];
    self.favorites = [manager getFavorites];
    [manager updateList:self];
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
    cell.textLabel.text = a.title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        NSLog(@"add %@", a.tid);
    } else if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.favorites removeObject:a.tid];
        NSLog(@"remove %@", a.tid);
    }
    AnimeDataManager *m = [AnimeDataManager sharedInstance];
    [m setFavorites:self.favorites];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Anime *a = [self.animeList objectAtIndex:indexPath.row];
    NSLog(@"%@", a.title);
}

- (void)buildView:(NSMutableArray *)animes
{
    self.animeList = animes;
    [self.tableView reloadData];
    NSLog(@"buildView");
    NSLog(@"size=%d", self.animeList.count);
}

@end
