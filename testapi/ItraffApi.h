//
//  ItraffApi.h
//
//  Created by iTraff Technology.
//

#import <Foundation/Foundation.h>

#define MIN_AREA_SINGLE 50000 //minimal image area for single object recognition mode
#define MAX_AREA_SINGLE 300000 //maximal image area for single object recognition mode

#define MIN_AREA_MULTI 100000 //minimal image area for single object recognition mode
#define MAX_AREA_MULTI 5000000  //maximal image area for single object recognition mode, in fact max is 12M but we use 5M not to send it too long

@interface ItraffApi : NSObject {
@protected
    NSString *_id;
    const char *_key;
    bool multiMode;
    bool allResults;
}

/*!
 @abstract set client id and api key
 @param clientId
 client id received at http://recognize.im
 @param apiKey
 corresponding api key
 */
-(id)initWithKey
    :(NSString *) clientId
    :(NSString *) apiKey
    :(bool)multi
    :(bool)all
;

/*!
 @abstract send image for recognition
 @param jpgImage
 Image to send
 @param delegate
 NSURLConnection delegate.
 Use didReceiveData to handle received json message.
 
 Sample success message:
 {
    status: 0,
    id: "<ID>"
 }
 
 Sample error message:
 {
    status: 1,
    message: "Invalid message hash"
 }
 
 Sample no match message:
 {
    status: 2,
    message: "No match found"
 }
 
 */
-(void) send
    :(UIImage *) jpgImage
    :(id<NSURLConnectionDataDelegate>) delegate
;

/**
 * Resizes the images so that it conforms to the recognize.im image size limits.
 */
-(UIImage *) resizeImage :(UIImage *) jpgImage :(bool) multi;

@end
