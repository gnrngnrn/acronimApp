//
//  LogOutViewController.h
//  AcronimApp
//
//  Created by Gnrn on 17.02.15.
//  Copyright (c) 2015 Gnrn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SWRevealViewController.h"
#import "LoginViewController.h"

@interface LogOutViewController : UIViewController <FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet FBLoginView *logView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end
