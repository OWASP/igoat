#import "NSURL+Parameters.h"

@implementation NSURL (Parameters)
-(NSDictionary *)parmetersInfo; {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:self
                                                resolvingAgainstBaseURL:NO];
    NSArray *queryItems = urlComponents.queryItems;
    
    NSMutableDictionary *queryStringDictionary = [@{} mutableCopy];
    for (NSURLQueryItem *queryItem in queryItems)
    {
        NSString *value = queryItem.value ? queryItem.value : @"";
        [queryStringDictionary setObject:value forKey:queryItem.name];
    }
    return queryStringDictionary.copy;
}

@end
