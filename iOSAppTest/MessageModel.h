//
//  MessageModel.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/09/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageModel : NSObject

- (NSMutableArray*)getMessages:(NSMutableArray*)messageList;
- (BOOL)existNotification:(NSString*)notificationToValidate withMessagesArray:(NSMutableArray*)messageList;
- (NSString*)getPhotoID:(NSString*)facebookLink;
- (NSString*)getCommentID:(NSString*)facebookLink;
- (NSMutableArray*)getNewNotifications:(NSArray*)arrayResultsData withMessagesArray:(NSMutableArray*)messageList;
- (NSString*)getMessagesIDs:(NSMutableArray*)messagesArray;

@end
