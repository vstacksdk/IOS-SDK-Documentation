- (UIViewController *) vsRequestUserInfoController:(VStackUser *)user withVStackUserId:(NSString *)vStackUserId {

    // Return your friend info controller

    ContactController * controller = [[ContactController alloc] init];
    controller.vStackUserId = vStackUserId;

    return controller;
    
    // Return nil to use default friend info controller in SDK
    // return nil;
}
