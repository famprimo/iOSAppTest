//
//  ViewController.m
//  iOSAppTest
//
//  Created by Federico Amprimo on 14/08/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ViewController.h"
#import "Message.h"
#import "MessageModel.h"

@interface ViewController ()
{
    NSMutableArray *MessagesArray;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    [_loginView setReadPermissions:@[@"public_profile"]];
    [_loginView setDelegate:self];
    _objectID = nil;

    MessagesArray = [[[MessageModel alloc] init] getMessages:MessagesArray];

}


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"%@", user.name);
    self.labelUserName.text = user.name;
    self.profilePictureView.profileID = user.objectID;
    
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"You are logged in!");
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"You are logged out!");
}


// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)requestNotifications:(id)sender

{
    
    [self makeRequestForNotifications];
    
    /*
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"public_profile", @"manage_notifications"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  // These are the current permissions the user has
                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                  
                                  // We will store here the missing permissions that we will have to request
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           if (!error) {
                                               // Permission granted, we can request the user information
                                               [self makeRequestForNotifications];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                               NSLog(@"error %@", error.description);
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestForNotifications];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          }];
    
    */
    
}

- (void) makeRequestForNotifications
{
    [FBRequestConnection startWithGraphPath:@"me/notifications?fields=application,link&include_read=true"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {

        if (!error) {
            // Success! Include your code to handle the results here
            
            if (result[@"data"]) {
                
                NSMutableArray *newMessagesArray = [[NSMutableArray alloc] init];
                NSMutableString *newMessagesFound = [[NSMutableString alloc] init];
                Message *tempMessage = [[Message alloc] init];
                MessageModel *messagesMethods = [[MessageModel alloc] init];

                BOOL foundNew = NO;
                
                NSArray *jsonArray = result[@"data"];
                
                // Look for "Photos" messages
                for (int i=0; i<jsonArray.count; i=i+1)
                {
                    NSDictionary *newMessage = jsonArray[i];
                    
                    if ([newMessage[@"application"][@"name"] isEqual: @"Photos"])
                    {
                        
                        if (![messagesMethods existNotification:newMessage[@"id"] withMessagesArray:MessagesArray])
                        {
                            // It's a new notification!

                            tempMessage = [[Message alloc] init];
                            tempMessage.fb_notif_id = newMessage[@"id"];
                            tempMessage.fb_link = newMessage[@"link"];
                            
                            // Take the photo ID and message ID from FB link
                            
                            NSMutableString *msgIDfromLink = [[NSMutableString alloc] init];
                            
                            [msgIDfromLink appendString:[messagesMethods getPhotoID:tempMessage.fb_link]];
                            tempMessage.fb_photo_id = msgIDfromLink;
                            
                            [msgIDfromLink appendString:@"_"];
                            
                            [msgIDfromLink appendString:[messagesMethods getCommentID:tempMessage.fb_link]];
                             
                            tempMessage.fb_msg_id = msgIDfromLink;
                            
                            // Add new message object
                            [newMessagesArray addObject:tempMessage];
                            
                            // Create string with messages IDs for FB request
                            if (foundNew)
                            {
                                [newMessagesFound appendString:@","];
                            }
                            else
                            {
                                foundNew = YES;
                            }
                            [newMessagesFound appendString:msgIDfromLink];

                        }
                    }
                }
                
                NSLog(@"New messages %@",newMessagesFound);
                
            }
            

        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"error %@", error.description);
        }
    }];
}


@end


