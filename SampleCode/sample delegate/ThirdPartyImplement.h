//
//  ThirdPartyImplement.h
//  VStack
//
//  Created by Nguyen Van Phu on 7/27/15.
//
//

#import <Foundation/Foundation.h>
#import <VStack/VStackManager.h>

@interface ThirdPartyImplement : NSObject <VSUserInfoDelegate, VSCallDelegate, VSChatDelegate>

+ (ThirdPartyImplement*)instance;

@property (nonatomic, weak) UINavigationController * navForChatController;

@end
