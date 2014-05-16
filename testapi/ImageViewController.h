//
//  ImageViewController.h
//
//  Created by iTraff Technology.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ImageViewController;

@protocol ImageViewControllerDelegate
- (void)imageViewControllerDidFinish:(ImageViewController *)controller;
@end

@interface ImageViewController : UIViewController{
    IBOutlet UIImageView *imageView;
}

@property (retain, nonatomic) id <ImageViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
- (void)showImage:(UIImage *)img withData:(NSArray *)dataArray;

@end
