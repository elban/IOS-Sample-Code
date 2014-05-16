//
//  ItraffResponse.h
//  testapi
//
//  Created by Marcin Nowak on 21.04.2014.
//
//

#import <Foundation/Foundation.h>
@class RecognizedLocation;
@class RecognizedObject;

@interface ItraffResponse : NSObject
{
    NSNumber * status;
    NSMutableArray * objects;
}


@property(nonatomic,retain) NSNumber * status;
@property(nonatomic,retain) NSMutableArray * objects;

+ (id) objectWithDictionary:(NSDictionary*)dictionary;
- (id) initWithDictionary:(NSDictionary*)dictionary;

@end