//
//  RecognizedObject.h
//  testapi
//
//  Created by Marcin Nowak on 21.04.2014.
//
//

#import <Foundation/Foundation.h>

@interface RecognizedObject : NSObject
{
    NSString * identity;
    NSString * name;
    NSMutableArray * location;
}

@property(nonatomic,retain) NSString * identity;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSMutableArray * location;

+ (id) objectWithDictionary:(NSDictionary*)dictionary;
- (id) initWithDictionary:(NSDictionary*)dictionary;

@end
