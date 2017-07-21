//
//  User+CoreDataProperties.m
//  iGoat
//
//  Created by Swaroop Yermalkar on 19/05/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic email;
@dynamic password;

@end
