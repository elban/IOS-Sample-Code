//
//  RecognizedLocation.h
//  testapi
//
//  Created by Marcin Nowak on 21.04.2014.
//
//

#import <Foundation/Foundation.h>

@interface RecognizedLocation : NSObject
{
    NSNumber * x;
    NSNumber * y;
}

@property(nonatomic,retain) NSNumber * x;
@property(nonatomic,retain) NSNumber * y;

+ (id) objectWithDictionary:(NSDictionary*)dictionary;
- (id) initWithDictionary:(NSDictionary*)dictionary;

@end
