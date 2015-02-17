//
//  LogOutViewController.m
//  AcronimApp
//
//  Created by Gnrn on 17.02.15.
//  Copyright (c) 2015 Gnrn. All rights reserved.
//

#import "LogOutViewController.h"

@interface LogOutViewController ()

@end

@implementation LogOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logView.readPermissions = @[@"public_profile"];
    SWRevealViewController *revealController = self.revealViewController;
    if (revealController) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
        LoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
        [self presentViewController:controller animated:YES completion:nil];
}

@end
