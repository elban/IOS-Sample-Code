//
//  MainViewController.h
//
//  Created by iTraff Technology.
//

#import "FlipsideViewController.h"
#import "ImageViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, ImageViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate> {
    IBOutlet UITextField *client, *clientKey;
    IBOutlet UITextView *responseText;
    IBOutlet UISwitch *multiModeSwitch;
    IBOutlet UISwitch *allResultsSwitch;
    IBOutlet UIButton *showImageButton;
}

- (IBAction)showInfo:(id)sender;
- (IBAction)showImage:(id)sender;

- (IBAction)makePhoto:(id)sender;

@end
