//
//  MoveViewController.m
//  iOSAppTest
//
//  Created by Federico Amprimo on 16/10/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "MoveViewController.h"
#import "Message.h"
#import "MessageModel.h"
#import <FacebookSDK/FacebookSDK.h>

@interface MoveViewController ()
{
    NSMutableArray *MessagesArray;
}
@end

@implementation MoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    MessagesArray = [[[MessageModel alloc] init] getMessages:MessagesArray];

    [self makeRequestForNotifications];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) makeRequestForNotifications
{
    MessageModel *messagesMethods = [[MessageModel alloc] init];
    
    [FBRequestConnection startWithGraphPath:@"me/notifications?fields=application,link&include_read=true"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              if (!error) {  // FB request was a success!
                                  
                                  if (result[@"data"]) {   // There is FB data!
                                      
                                      NSArray *jsonArray = result[@"data"];
                                      NSMutableArray *newMessagesArray = [[NSMutableArray alloc] init];
                                      
                                      // Get new notifactions
                                      newMessagesArray = [messagesMethods getNewNotifications:jsonArray withMessagesArray:MessagesArray];
                                      
                                      // Get message details for those notifications
                                      newMessagesArray = [self makeRequestForMessageDetails:newMessagesArray];
                                      
                                      
                                      // Code for sorting arrays
                                      
                                      NSArray *sortedArray;
                                      sortedArray = [newMessagesArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                                          NSDate *first = [(Message*)a datetime];
                                          NSDate *second = [(Message*)b datetime];
                                          return [first compare:second];
                                      }];
                                      
                                      NSLog(@"Array");
                                      
                                      
                                      
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          }];
}

- (NSMutableArray*) makeRequestForMessageDetails:(NSMutableArray*)messagesArray;
{
    
    MessageModel *messagesMethods = [[MessageModel alloc] init];
    NSMutableArray *updatedMessagesArray = [[NSMutableArray alloc] init];
    
    // Create string for FB request
    NSMutableString *requestMessagesList = [[NSMutableString alloc] init];
    [requestMessagesList appendString:@"?ids="];
    [requestMessagesList appendString:[messagesMethods getMessagesIDs:messagesArray]];
    
    // NSLog(@"request para FB: %@", requestMessagesList);
    
    [FBRequestConnection startWithGraphPath:requestMessagesList
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              if (!error) { // FB request was a success!
                                  
                                  Message *tempMessage;
                                  
                                  for (int i=0; i<messagesArray.count; i=i+1)
                                  {
                                      tempMessage = [[Message alloc] init];
                                      tempMessage = (Message *)messagesArray[i];
                                      
                                      tempMessage.message = result[tempMessage.fb_msg_id][@"message"];
                                      tempMessage.fb_from_id = result[tempMessage.fb_msg_id][@"from"][@"id"];
                                      tempMessage.fb_from_name = result[tempMessage.fb_msg_id][@"from"][@"name"];
                                      
                                      [updatedMessagesArray addObject:tempMessage];
                                  }
                                  
                              }
                              else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          } ];
    
    return updatedMessagesArray;
}



@end
