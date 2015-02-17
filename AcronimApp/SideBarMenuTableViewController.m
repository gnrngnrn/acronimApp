//
//  SideBarMenuTableViewController.m
//  core
//
//  Created by Gnrn on 16.02.15.
//  Copyright (c) 2015 Gnrn. All rights reserved.
//

#import "SideBarMenuTableViewController.h"
#import "SWRevealViewController.h"

@interface SideBarMenuTableViewController ()

@end

@implementation SideBarMenuTableViewController
{
    NSArray *menuItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    menuItems = @[@"title",@"acronim search",@"application info",@"company info",@"developer info",@"log out"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
}


@end
