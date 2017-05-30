

#import <Realm/Realm.h>

@interface RCreditInfo : RLMObject
    @property (nonatomic, strong) NSString *name;
    @property (nonatomic, strong) NSString *cardNumber;
    @property (nonatomic, strong) NSString *cvv;
@end
