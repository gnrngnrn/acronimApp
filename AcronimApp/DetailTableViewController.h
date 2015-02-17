//
//  DetailTableViewController.h
//  TestACR
//
//  Created by Gnrn on 14.02.15.
//  Copyright (c) 2015 Gnrn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Result.h"
#import "VariationsViewController.h"

@interface DetailTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *resultData;
@property (strong,nonatomic) NSString *str;

@end
