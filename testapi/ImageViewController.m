//
//  ImageViewController.m
//
//  Created by iTraff Technology.
//

#import "ImageViewController.h"
#import "RecognizedObject.h"
#import "RecognizedLocation.h"

#define ARC4RANDOM_MAX      0x100000000


@interface ImageViewController ()

@end

@implementation ImageViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate imageViewControllerDidFinish:self];
}

- (void)showImage:(UIImage *)img withData:(NSArray *)dataArray{
    UIGraphicsBeginImageContext(img.size);
    
    [img drawAtPoint:CGPointMake(0,0)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5.0);
    
    
    for (RecognizedObject *recognizedObject in dataArray) {
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), ((double)arc4random() / ARC4RANDOM_MAX), ((double)arc4random() / ARC4RANDOM_MAX), ((double)arc4random() / ARC4RANDOM_MAX), 1.0);
        CGContextBeginPath(UIGraphicsGetCurrentContext());

        CGFloat scale = 1;
        RecognizedLocation *firstLocation = [recognizedObject.location firstObject];

        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), [firstLocation.x floatValue] * scale, [firstLocation.y floatValue] * scale);
        for (int i = 1; i < [recognizedObject.location count]; i++) {
            RecognizedLocation *location = [recognizedObject.location objectAtIndex:i];
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), [location.x floatValue] * scale, [location.y floatValue] * scale);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), [location.x floatValue] * scale, [location.y floatValue] * scale);
        }

        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), [firstLocation.x floatValue] * scale, [firstLocation.y floatValue] * scale);

    }
    
    CGContextStrokePath(context);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [imageView setImage:newImage];
}





@end
