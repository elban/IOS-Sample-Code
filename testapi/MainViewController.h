//
//  MainViewController.h
//
//  Created by iTraff Technology.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate> {
    IBOutlet UITextField *client, *clientKey;
    IBOutlet UITextView *responseText;
    IBOutlet UISwitch *multiModeSwitch;
    IBOutlet UISwitch *allResultsSwitch;
}

- (IBAction)showInfo:(id)sender;

- (IBAction)makePhoto:(id)sender;

@end
