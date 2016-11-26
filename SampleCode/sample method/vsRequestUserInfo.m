
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
