//
//  GeneralViewController.m
//  core
//
//  Created by Gnrn on 15.02.15.
//  Copyright (c) 2015 Gnrn. All rights reserved.
//

#import "GeneralViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

@interface GeneralViewController ()

@end

@implementation GeneralViewController

@synthesize fetchedResultController = _fetchedResultController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appdelegate managedObjectContext];
    self.userName = appdelegate.userName;
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error - %@",error);
        abort();
    }
    SWRevealViewController *revealController = self.revealViewController;
    if (revealController) {
        self.menuButton.target = self.revealViewController;
        self.menuButton.action = @selector(revealToggle:);
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [self.indicator setHidden:YES];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Result *res = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = res.acronim;
    NSArray *ar = (NSArray *) res.unparsedResult;
    NSString *resString = [NSString stringWithFormat:@"%@ - %lu results",res.dateOfSearch,(unsigned long)ar.count];
    [cell.detailTextLabel setText: resString];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = self.managedObjectContext;
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailTableViewController *controller = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Result *object = (Result *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    NSArray *ar = (NSArray *)object.unparsedResult;
    controller.resultData = ar;
}

#pragma mark - Get Result Metods


- (IBAction)getAcronim:(id)sender
{
    if ([self.acronimField.text isEqualToString:@""]) {
        return;
    }
    [self.indicator setHidden:NO];
    [self.indicator startAnimating];
    NSString *const BASE_URL_STRING = @"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=";
    NSString *acronimSearchURLText = [NSString stringWithFormat:@"%@%@",
                                      BASE_URL_STRING, self.acronimField.text];
    NSURL *finalURL = [NSURL URLWithString:acronimSearchURLText];
    NSURLRequest *request = [NSURLRequest requestWithURL:finalURL];
    [request description];
    AFHTTPSessionManager *aFManager = [AFHTTPSessionManager manager];
    aFManager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    jsonReponseSerializer.acceptableContentTypes = nil;
    aFManager.responseSerializer = jsonReponseSerializer;
    [aFManager GET:[finalURL absoluteString]
        parameters:nil
           success:^(NSURLSessionDataTask *task, id responseObject) {
               NSArray *ar = (NSArray *) responseObject;
               if (ar.count == 0 ) {
                   [self addResultWithAcronim:self.acronimField.text andAmount:0 andSetUnparsedArray : nil andUserMane : self.userName];
                   [self saveContext];
                   return;
               }else{
                   NSArray *lfs = [self parseResponseToObject:[ar objectAtIndex:0]];
                   [self addResultWithAcronim:self.acronimField.text andAmount:lfs.count andSetUnparsedArray : lfs andUserMane : self.userName];
                   [self saveContext];
                   DetailTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailController"];
                   controller.resultData = lfs;
                   [self.navigationController pushViewController:controller animated:YES];
               }
           }
           failure:^(NSURLSessionDataTask *task, NSError *error) {
               NSLog(@"FAIL!: - %@",error);
           }];
    [self.indicator stopAnimating];
    [self.indicator setHidden:YES];
}

-(NSArray *)parseResponseToObject : (NSDictionary *) response
{
    NSArray *ar = [response objectForKey:@"lfs"];
    return ar;
}

-(void) addResultWithAcronim:(NSString*)acronim andAmount : (int) amounts andSetUnparsedArray : (NSArray *) array andUserMane : (NSString *) nameUser
{
    Result *res = (Result *)[NSEntityDescription insertNewObjectForEntityForName:@"Result" inManagedObjectContext:self.managedObjectContext];
    res.amount = [NSNumber numberWithInteger:amounts];
    res.acronim = acronim;
    res.unparsedResult = array;
    res.name = nameUser;
    res.dateOfSearch = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                      dateStyle:NSDateFormatterShortStyle
                                                      timeStyle:NSDateFormatterShortStyle];
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    [self.acronimField resignFirstResponder];
}


#pragma mark - Fetchet methods

-(NSFetchedResultsController *) fetchedResultsController
{
    if (_fetchedResultController != nil) {
        return _fetchedResultController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Result" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", self.userName];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateOfSearch"
                                                                   ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    _fetchedResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultController.delegate = self;
    return _fetchedResultController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            break;
        case NSFetchedResultsChangeMove:
            break;
    }
}
- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
