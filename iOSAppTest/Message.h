//
//  Message.h
//  GarageSaleApp
//
//  Created by Federico Amprimo on 12/09/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (strong, nonatomic) NSString *fb_notif_id;
@property (strong, nonatomic) NSString *fb_msg_id;
@property (strong, nonatomic) NSString *fb_from_id;
@property (strong, nonatomic) NSString *fb_from_name;
@property (strong, nonatomic) NSString *fb_link;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *fb_created_time;
@property (strong, nonatomic) NSString *fb_photo_id;
@property (strong, nonatomic) NSString *from_client_id;
@property (strong, nonatomic) NSString *agent_id;
@property (strong, nonatomic) NSString *status; // (N)ew (R)ead (D)one
@property (strong, nonatomic) NSString *type; // (P)hoto comment (I)nbox

@end
