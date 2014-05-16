//
//  RecognizedObject.m
//  testapi
//
//  Created by Marcin Nowak on 21.04.2014.
//
//

#import "RecognizedObject.h"
#import "RecognizedLocation.h"

@implementation RecognizedObject
@synthesize identity;
@synthesize name;
@synthesize location;


+ (id) objectWithDictionary:(NSDictionary*)dictionary
{
    id obj = [[RecognizedObject alloc] initWithDictionary:dictionary];
    return obj;
}

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    self=[super init];
    if(self)
    {
        identity = [dictionary objectForKey:@"id"];
        name = [dictionary objectForKey:@"name"];
        
        NSArray* temp =  [dictionary objectForKey:@"location"];
        location =  [[NSMutableArray alloc] init];
        for (NSDictionary *d in temp) {
            [location addObject:[RecognizedLocation objectWithDictionary:d]];
        }
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"id: %@, name: %@, location: %@", identity, name, location];
}

@end
