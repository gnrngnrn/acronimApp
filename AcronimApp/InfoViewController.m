//
//  InfoViewController.m
//  core
//
//  Created by Gnrn on 16.02.15.
//  Copyright (c) 2015 Gnrn. All rights reserved.
//

#import "InfoViewController.h"
#import "SWRevealViewController.h"
@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SWRevealViewController *revealController = self.revealViewController;
    if (revealController) {
        self.menuButton.target = self.revealViewController;
        self.menuButton.action = @selector(revealToggle:);
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

@end
