//
//  ItraffApi.m
//
//  Created by iTraff Technology.
//

#import "ItraffApi.h"

#import <CommonCrypto/CommonDigest.h>

@implementation ItraffApi

-(id)initWithKey
    :(NSString *)clientId 
    :(NSString *)apiKey
    :(bool) multi
    :(bool) all
{
    self = [super init];
    
    if (self) {
        self->_id = clientId;
        self->_key = [apiKey UTF8String];
        self->multiMode = multi;
        self->allResults = all;
    }
    
    return self;
}

/*!
 @abstract extract data from image
 @param source
 source image
 @return NSData image data
 */
-(NSData *)imageData
    :(UIImage *)source
{
	return UIImageJPEGRepresentation(source, 0.6);
}

/*!
 @abstract generate md5
 @param image
 image data
 @return NSString hash as a 32-character hexadecimal number
 */
- (NSString *)hash
    :(NSData *)image
{
    if (strlen(_key) < 1)
        return nil;
    
    CC_MD5_CTX c;
    CC_MD5_Init(&c);
    CC_MD5_Update(&c, _key, strlen(_key));
    CC_MD5_Update(&c, [image bytes], [image length]);
    unsigned char result[16];
    CC_MD5_Final(result, &c);
    return [NSString stringWithFormat:
        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
        result[0], result[1], result[2], result[3], 
        result[4], result[5], result[6], result[7],
        result[8], result[9], result[10], result[11],
        result[12], result[13], result[14], result[15]
    ];  
}



- (void) send
    :(UIImage *) jpgImage
    :(id<NSURLConnectionDataDelegate>) delegate
{
    NSData *data = [self imageData:[self resizeImage:jpgImage:multiMode]];
//    NSData *data = [self imageData:jpgImage];
    NSString *url;
    if (multiMode) {
        if (allResults) {
            url = [NSString stringWithFormat:@"http://recognize.im/v2/recognize/multi/all/%@", _id];
        } else {
            url = [NSString stringWithFormat:@"http://recognize.im/v2/recognize/multi/%@", _id];
        }
    } else {
        if (allResults) {
            url = [NSString stringWithFormat:@"http://recognize.im/v2/recognize/single/all/%@", _id];
        } else {
            url = [NSString stringWithFormat:@"http://recognize.im/v2/recognize/single/%@", _id];
        }
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"image/jpeg" forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[self hash:data] forHTTPHeaderField:@"X-iTraff-hash"];
    [request setHTTPBody:data];
    [[[NSURLConnection alloc] initWithRequest:request delegate:delegate] start];
}

-(UIImage *) resizeImage :(UIImage *) jpgImage :(bool) multi {
  
    
    float area = jpgImage.size.width * jpgImage.size.height;
    
    int minArea = MIN_AREA_SINGLE; //min area for single object recognition
    int maxArea = MAX_AREA_SINGLE; //max area for single object recognition
    if (multi) { //we are in multi objects objects recognition mode
        minArea = MIN_AREA_MULTI;
        maxArea = MAX_AREA_MULTI;
    }
    
    if (area > minArea && area < maxArea) {
        return jpgImage;
    }
    float scale = 0.0f;
    if (area < minArea) {
        scale = (float) sqrt((minArea + 1000) / area);
    } else {
        scale = (float) sqrt(maxArea / area);
    }
    
    CGFloat newWidth = jpgImage.size.width * scale;
    CGFloat newHeight = jpgImage.size.height * scale;
    
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIImageWriteToSavedPhotosAlbum(jpgImage, self,  @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    UIGraphicsBeginImageContext(newSize);
    [jpgImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(newImage, self,  @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    return newImage;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {

}

@end
