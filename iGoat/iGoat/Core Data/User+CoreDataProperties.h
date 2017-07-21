//
//  User+CoreDataProperties.h
//  iGoat
//
//  Created by Swaroop Yermalkar on 19/05/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *password;

@end

NS_ASSUME_NONNULL_END
