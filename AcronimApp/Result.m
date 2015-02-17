//
//  Result.m
//  AcronimApp
//
//  Created by Gnrn on 17.02.15.
//  Copyright (c) 2015 Gnrn. All rights reserved.
//

#import "Result.h"


@implementation Result

@dynamic dateOfSearch;
@dynamic amount;
@dynamic acronim;
@dynamic name;
@dynamic unparsedResult;

+ (Class)transformedValueClass
{
    return [NSArray class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
