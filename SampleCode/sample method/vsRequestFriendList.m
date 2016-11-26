- (NSArray *) vsRequestFriendList{
    NSMutableArray * users = [[NSMutableArray alloc] init];
    
    VStackUser * user1 = [[VStackUser alloc] init];
    user1.fullname = @"phunv8";
    user1.vStackUserId = @"phunv8";
    
    VStackUser * user2 = [[VStackUser alloc] init];
    user2.fullname = @"anhtt";
    user2.vStackUserId = @"anhtt";
    
    VStackUser * user3 = [[VStackUser alloc] init];
    user3.fullname = @"gianglh";
    user3.vStackUserId = @"gianglh";
    
    VStackUser * user4 = [[VStackUser alloc] init];
    user4.fullname = @"luannb3";
    user4.vStackUserId = @"luannb3";
    
    VStackUser * user5 = [[VStackUser alloc] init];
    user5.fullname = @"tannt4";
    user5.vStackUserId = @"tannt4";
    
    VStackUser * user6 = [[VStackUser alloc] init];
    user6.fullname = @"0912323549823";
    user6.vStackUserId = @"0912323549823";
    
    VStackUser * user7 = [[VStackUser alloc] init];
    user7.fullname = @"091232354982345";
    user7.vStackUserId = @"091232354982345";
    
    [users addObject:user1];
    [users addObject:user2];
    [users addObject:user3];
    [users addObject:user4];
    [users addObject:user5];
    
    [users addObject:user6];
    [users addObject:user7];
    
    return users;
}
