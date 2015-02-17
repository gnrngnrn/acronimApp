//
//  Result.h
//  AcronimApp
//
//  Created by Gnrn on 17.02.15.
//  Copyright (c) 2015 Gnrn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Result : NSManagedObject

@property (nonatomic, retain) NSString * dateOfSearch;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * acronim;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id unparsedResult;

@end
