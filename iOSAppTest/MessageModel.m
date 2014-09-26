//
//  MessageModel.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/09/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (NSMutableArray*)getMessages:(NSMutableArray*)messageList;
{
    // Array to hold the listing data
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    // Create message #1
    Message *tempMessage = [[Message alloc] init];
    tempMessage.fb_notif_id = @"153344961539458_1378402423";
    tempMessage.fb_msg_id = @"153344961539458_1378402423";
    tempMessage.fb_from_id = @"10203554768023190";
    tempMessage.fb_from_name = @"Mily de la Cruz";
    tempMessage.fb_link = @"XXXXX";
    tempMessage.message = @"Me interesa. Enviar datos al inbox";
    tempMessage.fb_created_time = @"2014-09-20T18:45:38+0000";
    tempMessage.fb_photo_id = @"XXXXX";
    tempMessage.from_client_id = @"00006";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"N";
    tempMessage.type = @"I";
   
    // Add message #1 to the array
    [messages addObject:tempMessage];
    
    // Create message #2
    tempMessage = [[Message alloc] init];
    tempMessage.fb_notif_id = @"notif_329073340603857_14353045";
    tempMessage.fb_msg_id = @"1469889866608936_1408489028";
    tempMessage.fb_from_id = @"10152156045491377";
    tempMessage.fb_from_name = @"Amparo Gonzalez";
    tempMessage.fb_link = @"XXXXX";
    tempMessage.message = @"Cuales son las medidas?";
    tempMessage.fb_created_time = @"2014-09-20T18:45:38+0000";
    tempMessage.fb_photo_id = @"XXXXX";
    tempMessage.from_client_id = @"00004";
    tempMessage.agent_id = @"00001";
    tempMessage.status = @"P";
    
    // Add message #2 to the array
    [messages addObject:tempMessage];
    
    // Return the producct array as the return value
    return messages;
}

- (BOOL)existNotification:(NSString*)notificationToValidate withMessagesArray:(NSMutableArray*)messageList;
{
    BOOL exists = NO;
    
    Message *messageToValidate = [[Message alloc] init];
   
    for (int i=0; i<messageList.count; i=i+1)
    {
        messageToValidate = [[Message alloc] init];
        messageToValidate = (Message *)messageList[i];
        
        if ([messageToValidate.fb_notif_id isEqual:notificationToValidate])
        {
            exists = YES;
            break;
        }
    }
    return exists;
}

- (NSString*)getPhotoID:(NSString*)facebookLink;
{
    NSString *photoID;
    
    // Search for 'fbid=' to get photo_id
    
    NSRange searchForPhotoId = [facebookLink rangeOfString:@"fbid="];
    NSRange searchForDelimiter = [facebookLink rangeOfString:@"&"];
    
    int locationPhotoID = (int) searchForPhotoId.location + 5;
    int lengthPhotoID =  (int) searchForDelimiter.location - locationPhotoID;
    
    photoID = [facebookLink substringWithRange: NSMakeRange(locationPhotoID, lengthPhotoID)];
    
    return photoID;
}


- (NSString*)getCommentID:(NSString*)facebookLink;
{
    NSString *commentID;

    // Search for 'comment_id=' to get _id
  
    NSRange searchForCommentId = [facebookLink rangeOfString:@"comment_id="];
    
    int locationCommentID = (int) searchForCommentId.location + 11;
    
    NSString *textForSearch = [facebookLink substringWithRange: NSMakeRange(locationCommentID, facebookLink.length - locationCommentID)];
    

    NSRange searchForDelimiter = [textForSearch rangeOfString:@"&"];
    int lengthCommentID =  (int) searchForDelimiter.location;

    commentID = [facebookLink substringWithRange: NSMakeRange(locationCommentID, lengthCommentID)];

    return commentID;
}


- (NSMutableArray*)getNewNotifications:(NSArray*)arrayResultsData withMessagesArray:(NSMutableArray*)messageList;
{
    // Method that takes the result of a call to FB and return the new notifications
    
    NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
    
    Message *tempMessage = [[Message alloc] init];
    MessageModel *messagesMethods = [[MessageModel alloc] init];
    
    // Look for "Photos" notifications
    
    for (int i=0; i<arrayResultsData.count; i=i+1)
    {
        NSDictionary *newMessage = arrayResultsData[i];
        
        if ([newMessage[@"application"][@"name"] isEqual: @"Photos"]) {
            
            if (![messagesMethods existNotification:newMessage[@"id"] withMessagesArray:messageList]) {
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
                [messagesArray addObject:tempMessage];
                
            }
        }
    }
    
    return messagesArray;
    
}

- (NSString*)getMessagesIDs:(NSMutableArray*)messagesArray;
{
    // Method that returns the IDs of all the Messages in the array sent
    
    Message *tempMessage;
        
    NSMutableString *messagesIDList = [[NSMutableString alloc] init];
    
    for (int i=0; i<messagesArray.count; i=i+1)
    {
        if (i>0) { [messagesIDList appendString:@","]; }
        
        tempMessage = [[Message alloc] init];
        tempMessage = (Message *)messagesArray[i];
        
        [messagesIDList appendString:tempMessage.fb_msg_id];
    }
    
    return messagesIDList;
}

- (BOOL)updateMessagesArray:(NSMutableArray*)messagesArray withMessage:(NSString*)messageToUpdate forMessageID:(NSString*)messageID;
{
    // Method that search a Messages array and update an specific message with the details
    
    BOOL updateSuccessful = NO;
    
    return updateSuccessful;
}

@end
