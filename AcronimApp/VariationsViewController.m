//
//  VariationsViewController.m
//  TestACR
//
//  Created by Gnrn on 15.02.15.
//  Copyright (c) 2015 Gnrn. All rights reserved.
//

#import "VariationsViewController.h"

@interface VariationsViewController ()

@end

@implementation VariationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self parseVariants:self.variants];
}

-(void) parseVariants : (NSArray *) array
{
    NSMutableString *result = [[NSMutableString alloc]init ];
    for (id obj in array) {
        NSDictionary *dict = (NSDictionary *) obj;
        [result appendString:[NSString stringWithFormat:@"The surface form of the full form - %@.\n The number of occurrences of the surface form in the abbreviation definition in the corpus - %i.\n The year when the surface form appeared for the first time in the corpus - %i\n\n",[dict objectForKey:@"lf"],[[dict objectForKey:@"freq"] intValue],[[dict objectForKey:@"since"] intValue]]];
    }
    self.textField.text = result;
}

@end
