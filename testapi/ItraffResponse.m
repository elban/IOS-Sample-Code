//
//  ItraffResponse.m
//  testapi
//
//  Created by Marcin Nowak on 21.04.2014.
//
//

#import "ItraffResponse.h"
#import "RecognizedObject.h"

@implementation ItraffResponse
@synthesize status;
@synthesize objects;


+ (id) objectWithDictionary:(NSDictionary*)dictionary
{
    id obj = [[ItraffResponse alloc] initWithDictionary:dictionary] ;
    return obj;
}

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    self=[super init];
    if(self)
    {
        status = [dictionary objectForKey:@"status"];
        
        NSArray* temp =  [dictionary objectForKey:@"objects"];
        objects =  [[NSMutableArray alloc] init];
        for (NSDictionary *d in temp) {
            [objects addObject:[RecognizedObject objectWithDictionary:d]];
        }
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"status: %@, objects: %@", status, objects];
}


@end
