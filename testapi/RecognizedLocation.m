//
//  RecognizedLocation.m
//  testapi
//
//  Created by Marcin Nowak on 21.04.2014.
//
//

#import "RecognizedLocation.h"

@implementation RecognizedLocation
@synthesize x;
@synthesize y;

+ (id) objectWithDictionary:(NSDictionary*)dictionary
{
    id obj = [[RecognizedLocation alloc] initWithDictionary:dictionary];
    return obj;
}

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    self=[super init];
    if(self)
    {
        x = [dictionary objectForKey:@"x"];
        y = [dictionary objectForKey:@"y"];
    }
    return self;
}


-(NSString *)description{
    return [NSString stringWithFormat:@"x: %@, y: %@", x, y];
}

@end
