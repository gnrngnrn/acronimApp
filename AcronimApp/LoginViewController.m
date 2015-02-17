//
//  LoginViewController.m
//  AcronimApp
//
//  Created by Gnrn on 17.02.15.
//  Copyright (c) 2015 Gnrn. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    AppDelegate *appDelegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.logView.readPermissions = @[@"public_profile"];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    appDelegate.userName = user.name;
    [self pushSWReveal];
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    
}

-(void)pushSWReveal
{
    SWRevealViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (IBAction)noLogin:(id)sender
{
    appDelegate.userName = @"GENERAL";
    SWRevealViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
