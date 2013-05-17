//
//  MainViewController.m
//
//  Created by iTraff Technology.
//

#import "MainViewController.h"

#import "ItraffApi.h"

@interface MainViewController ()

@end

@implementation MainViewController

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

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
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

    
    [[[ItraffApi alloc] initWithKey:[client text] :[clientKey text] : multiModeSwitch.isOn : allResultsSwitch.isOn] send:image :self];
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [responseText setText:NSLocalizedString(@"Sending photo...", nil)]; 
    
    return request;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseText setText:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error", nil) message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];  
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
