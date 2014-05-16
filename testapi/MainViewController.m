//
//  MainViewController.m
//
//  Created by iTraff Technology.
//

#import "MainViewController.h"

#import "ItraffApi.h"
#import "ItraffResponse.h"

@interface MainViewController ()
@property (nonatomic, retain) UIImage *imageToSend;
@property (nonatomic, retain) ItraffResponse *iTraffResponse;

@end

@implementation MainViewController
@synthesize iTraffResponse;

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:NO];
    return NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [client setText:[defaults objectForKey:@"clientId"]];
    [clientKey setText:[defaults objectForKey:@"clientKey"]];
    
    [multiModeSwitch setOn:NO]; // setting multi mode off
    [allResultsSwitch setOn:NO]; //setting  showing all results off
    
    UIButton *dismissKeyboard = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissKeyboard setFrame:[self.view frame]];
    [dismissKeyboard addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:dismissKeyboard atIndex:0];
    
//    iTraffResponse = [[ItraffResponse alloc]init];
}

- (IBAction)close:(id)sender
{
    [self.view endEditing:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Image View

- (void)imageViewControllerDidFinish:(ImageViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)showImage:(id)sender{
    if (self.imageToSend) {
        ImageViewController *controller = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
//        [controller view];
        
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:controller animated:YES];
        [controller showImage:self.imageToSend withData:iTraffResponse.objects];
    }
}

- (IBAction)makePhoto:(id)sender
{
    if (![[client text] length]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Enter Client Id", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Camera not available", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    UIImagePickerController *picker = [UIImagePickerController new];
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [picker setShowsCameraControls:YES];
    [picker setDelegate:self];
    [self presentModalViewController:picker animated:YES];    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [self dismissModalViewControllerAnimated:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[client text] forKey:@"clientId"];
    [defaults setObject:[clientKey text] forKey:@"clientKey"];
    [defaults synchronize];

    
    ItraffApi *api = [[ItraffApi alloc] initWithKey:[client text] :[clientKey text] : multiModeSwitch.isOn : allResultsSwitch.isOn] ;
    self.imageToSend = [api resizeImage:image :multiModeSwitch.isOn];
    NSLog(@"width: %fx%f", self.imageToSend.size.width, self.imageToSend.size.height );
    [api send:image :self ];

}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [responseText setText:NSLocalizedString(@"Sending photo...", nil)]; 
    
    return request;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableLeaves
                                                               error:nil];
    
    NSString *response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"log: %@", response);
//    NSDictionary *responseDict = [response JSONValue];
    
    [responseText setText:response];
    
    iTraffResponse = [[ItraffResponse alloc]initWithDictionary:responseDict];
    
    if ([iTraffResponse.status intValue] == 0) {
        [showImageButton setHidden:NO];
    } else {
        [showImageButton setHidden:YES];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error", nil) message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];  
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
