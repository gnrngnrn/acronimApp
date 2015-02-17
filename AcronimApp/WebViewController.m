//
//  WebViewController.m
//  core
//
//  Created by Gnrn on 16.02.15.
//  Copyright (c) 2015 Gnrn. All rights reserved.
//

#import "WebViewController.h"
#import "SWRevealViewController.h"
@interface WebViewController ()

@end

@implementation WebViewController{
    NSString *path;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    path = @"http://gbksoft.com/";
    NSURL *url = [NSURL URLWithString:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    SWRevealViewController *revealController = self.revealViewController;
    if (revealController) {
        self.menuButton.target = self.revealViewController;
        self.menuButton.action = @selector(revealToggle:);
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}


@end
