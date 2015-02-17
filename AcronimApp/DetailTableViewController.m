//
//  DetailTableViewController.m
//  TestACR
//
//  Created by Gnrn on 14.02.15.
//  Copyright (c) 2015 Gnrn. All rights reserved.
//

#import "DetailTableViewController.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
    NSDictionary *dict = (NSDictionary *)self.resultData[indexPath.row];
    [cell.textLabel setText:[dict objectForKey:@"lf"]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"First mentioned in %li. Number of occurances - %li",(long)[[dict objectForKey:@"since"] integerValue],(long)[[dict objectForKey:@"freq"] integerValue]]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VariationsViewController *controller = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    controller.variants = [ self.resultData[path.row] objectForKey:@"vars"];
}

@end
