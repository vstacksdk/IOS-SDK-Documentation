//
//  ThirdPartyImplement.m
//  VStack
//
//  Created by Nguyen Van Phu on 7/27/15.
//
//

#import "ThirdPartyImplement.h"
#import <VStack/VStackManager.h>
#import <VStack/VStackUser.h>

@implementation ThirdPartyImplement

- (id) init {
    self = [super init];
    if (self != nil) {
    }
    return self;
}

static ThirdPartyImplement *ins;

+ (ThirdPartyImplement*)instance {
    
    @synchronized(self) {
        if (!ins){
            ins = [[self alloc] init];
        }
    }
    return ins;
}

#pragma mark VStackUserInfoDelegate

- (void) vsRequestUserInfo:(NSArray *)vStackUserIds withTarget:(int)target{
    // Request user info in your server by HTTP, Socket... IMPORTANT: Your function doesnt block main thread
    // In this test project, We fake return user info
    
    NSMutableArray * userInfoArrays = [[NSMutableArray alloc] init];
    
    for (NSString * vStackUserId in vStackUserIds) {
        NSDictionary * fakeData =
                                @{
                                  @"vstackuserid": vStackUserId,
                                  @"sex": @(1),
                                  @"avatar": @"http://0.gravatar.com/avatar/ad516503a11cd5ca435acc9bb6523536?s=256",
                                  @"fullname": vStackUserId};
        [userInfoArrays addObject:fakeData];
    }
    
    // When you get user info in your server --> call this function to send user info to VStackSDK
    
    [[VStackManager instance] sendUserInfoToVStack:userInfoArrays withTarget:target];
}



- (NSArray *) vsRequestFriendList{
    NSMutableArray * users = [[NSMutableArray alloc] init];
    VStackUser * user1 = [[VStackUser alloc] init];
    user1.fullname = @"User 1";
    user1.vStackUserId = @"user1";
    
    VStackUser * user2 = [[VStackUser alloc] init];
    user2.fullname = @"User 2";
    user2.vStackUserId = @"user2";
    
    VStackUser * user3 = [[VStackUser alloc] init];
    user3.fullname = @"User 3";
    user3.vStackUserId = @"user3";
    
    VStackUser * user4 = [[VStackUser alloc] init];
    user4.fullname = @"User 4";
    user4.vStackUserId = @"user4";
    
    VStackUser * user5 = [[VStackUser alloc] init];
    user5.fullname = @"User 5";
    user5.vStackUserId = @"user5";
    
    VStackUser * user6 = [[VStackUser alloc] init];
    user6.fullname = @"User 6";
    user6.vStackUserId = @"user6";
    
    [users addObject:user1];
    [users addObject:user2];
    [users addObject:user3];
    [users addObject:user4];
    [users addObject:user5];
    [users addObject:user6];
    
    return users;
}

- (UIViewController *) vsRequestUserInfoController:(VStackUser *)user withVStackUserId:(NSString *)vStackUserId {
    // Return your controller friend info
    
    // Return nil to use default friend info controller
    return nil;
}

#pragma mark VStackChatDelegate

- (UINavigationController *) vsRequestNavigationToPushChatController{
    return self.navForChatController;
}

- (void) vsUpdateUnreadMessageCount:(int)unreadCount {
}

#pragma mark VStackCallDelegate

- (void) vsJustFinishCall:(NSDictionary *)callInfo{
    NSLog(@"Receive call log %@", callInfo);
}

#pragma mark Others

@end
