# 0. Quick Start
<!--<a href="https://www.youtube.com/watch?v=MTQo9T2Eua4" target="_blank">-->
<!--    <img src="http://azstack.com/docs/static/video_demo.png" alt=" " width="300" border="10" />-->
<!--</a>-->

Download demo project at: https://github.com/vstacksdk/ios-sdk-sample

# 1. Tạo ứng dụng
VStack sẽ cung cấp cho bạn ID của ứng dụng (appID) và 1 RSA key pair (public key, private key); appID và public key sẽ được lưu trong ứng dụng (client) của bạn, còn private key sẽ được lưu trên server của bạn.

# 2. Add the SDK to your Xcode Project
### 2.1. Download VStack Framework tại:

https://developer-vstack.vht.com.vn/SDK/iOS

>a. Giải nén bạn sẽ có: VStack.framework, VStackRes.bundle, VStackCall.a


>b. Drag the VStack.framework and VStackRes.bundle to Frameworks in Project Navigator. Create a new group Frameworks if it does not exist.

>c. Choose Create groups for any added folders.

>d. Deselect Copy items into destination group's folder. This references the SDK where you installed it rather than copying the SDK into your app.


![Add the SDK](http://az1.azstack.com/msg_guide/DragAndCopySDK.png "Add the SDK")


### 2.2. Configure Xcode Project
> a. Add Linker Flag
Open the "Build Settings" tab, in the "Linking" section, locate the "Other Linker Flags" setting and add the "-ObjC" flag:

![Add Linker Flag](http://az1.azstack.com/msg_guide/OthersLinkerFlags.png "Add Linker Flag")

Note:
Bước này là bắt buộc, nếu không khi chạy chương trình sẽ sinh lỗi crash:
```objective-c
[AzFMDatabase columnExists:inTableWithName:]: unrecognized selector sent to instance 0x...
```
> b. Add other frameworks and libraries
Open the "Build Phases" tab, in the "Link Binary With Libraries" section, add frameworks and libraries:

- CoreGraphics
- CoreLocation
- libxml2
- MobileCoreServices
- CoreMedia
- QuartzCore
- AssetsLibrary
- CoreTelephony
- CoreText
- MapKit
- libz
- SystemConfiguration
- AVFoundation
- ImageIO
- MessageUI
- Security
- CFNetwork
- AudioToolbox
- MediaPlayer
- libsqlite3.0.dylib
- libicucore
- libc++
- GLKit
- VideoToolbox

> c. Nếu bạn cần tính năng call trong ứng dụng add file "VStackCall.a" trong phần "Link Binary With Libraries".

![Add other frameworks and libraries]( http://az1.azstack.com/msg_guide/AddOtherFrameworksAndLibraries.png "Add other frameworks and libraries")

# 3. Concepts and flow

### 3.1. User ID

Mỗi user duy nhất của ứng dụng của bạn cần 1 định danh duy nhất trên VStack (dạng chuỗi): vStackUserID.

Ví dụ ứng dụng của bạn sử dụng email để định danh duy nhất người dùng. Bạn có 2 user: user1@email.com, user2@abc.com thì 2 người này cần 2 vStackUserID khác nhau, có thể là: user1_email_com, user2_abc_com hoặc có thể dùng chính email làm vStackUserID.

Tương tự nếu hệ thống của bạn sử dụng số điện thoại, username, ... để định danh duy nhất người dùng thì cũng có thể dùng chính số điện thoại, username, ... để làm vStackUserID.

Để tránh phức tạp thì định danh user trên hệ thống của bạn (username, email, phone number, ...) cũng nên là định danh trên VStack (vStackUserID).
2 app khác nhau có thể có 2 user trùng vStackUserID.

### 3.2. Authentication

Trước khi người dùng có thể gửi và nhận tin nhắn thì cần quá trình khởi tạo SDK và xác thực. Việc xác thực 1 user được thực hiện bởi 3 bên: client (VStack SDK), VStack server và server của bạn; đảm bảo việc bạn có thể cho phép / không cho phép 1 user nào đó xác thực / sử dụng dịch vụ chat/call bất cứ lúc nào.

Quá trình được mô tả bởi biểu đồ dưới:

![VStack init and authentication](http://az1.azstack.com/msg_guide/Android_Connect_Authenticate.png "VStack init and authentication")

#### Bước 0: 

Vào https://developer-vstack.vht.com.vn/
    
    a. Tạo project

    b. Generate secret code và 1 cặp khoá RSA

    c. Thiết lập địa chỉ nhận HTTP POST xác thực từ VStack trên server của bạn (Authentication URL)


#### Bước 1: 

Init SDK: thiết lập appID, publicKey sau đó gọi hàm [[VStackManager instance] initial]

#### Bước 2: 

Gọi hàm [[VStackManager instance] connectWithVStackUserID...] để bắt đầu quá trình xác thực

#### Bước 3: 

Sau khi bạn gọi hàm connectWithVStackUserID, SDK sẽ thực hiện mã hoá chuỗi: 

```objective-c
{"vStackUserID":"...", "userCredentials":"..."}
```

bằng thuật toán RSA 2048 với public key bạn cung cấp, chuỗi sau khi mã hoá gọi là: Identity Token sẽ được gửi lên VStack.

#### Bước 4: 

VStack sẽ giải mã Identity Token bằng thuật toán RSA 2048 với private key được sinh ra ở bước 0. Sau đó lại mã hoá chuỗi sau bằng chính public key sinh ra ở bước 0:

```objective-c
{"vStackUserID":"...", "userCredentials":"...", "timestamp": ..., "appId":"...", "code":"..."}
```

trong đó code bằng:

```objective-c
md5(appId + "_" + timestamp + "_" + secret_code)
```

Chuỗi được mã hoá sinh ra gọi là: Authentication Token. VStack sẽ gửi đến server của bạn bằng HTTP POST với url bạn cung cấp ở bước 0 (Authentication URL).

#### Bước 5: 

Server của bạn khi nhận HTTP POST từ VStack gọi sang để thực hiện xác thực cần giải mã chuỗi Authentication Token bằng private key sinh ra ở bước 0, kiểm tra lại code có đúng bằng: 

```objective-c
md5(appId + "_" + timestamp + "_" + secret_code)
```

hay không, sau đó thực hiện xác thực bằng cách kiểm tra vStackUserID và userCredentials trên database của bạn.

Please see sample code writing in PHP here: https://github.com/vstacksdk/backend-example/tree/master/php


# 4. Khởi tạo SDK
Bước khởi tạo VStack nên được đặt ngay lúc app khởi chạy, ngay đầu hàm:
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
```
### 4.1. Thiết lập AppID
```objective-c
[[VStackManager instance] setAppId:@"YOUR_APP_ID_HERE"];
```

### 4.2. Thiết lập Public Key
```objective-c
[[VStackManager instance] setPublicKey:@"YOUR_PUBLIC_KEY_HERE"];
```
### 4.3. Thiết lập các delegate của VStack:
- VSUserInfoDelegate
- VSChatDelegate
- VSCallDelegate

Chúng tôi sẽ giải thích các delegate này [tại bước 5]. Xem code mẫu tại đây: https://github.com/vstacksdk/ios-sdk-documentation/tree/master/SampleCode/sample%20delegate

### 4.4. Thiết lập 1 số thông số:
- Set màu title, button trên thanh navigation bar cho phù hợp với màu app của bạn

  Lưu ý: setup này sẽ chỉ có tác dụng trên các UIViewController của SDK chứ  không ảnh hưởng tới các UIViewController khác trong app của bạn

```objective-c
[[VStackManager instance] setTintColorNavigationBar:[UIColor whiteColor]];
```
- Set ngôn ngữ được hiển thị trong VStack SDK

  Mặc định ngôn ngữ của SDK sẽ lấy ngôn ngữ hệ thống, nếu SDK không hỗ trợ ngôn ngữ đó thì tự động chuyển sang tiếng anh.

```objective-c
[[VStackManager instance] setLanguage:@"vi"];
```
  Tham số truyền vào là mã ngôn ngữ. VD: Tiếng Anh là “en”, Tiếng Việt là “vi” 

- Set hiển thị debug log:

  Cho phép hiển thị debug log của SDK hay không?

```objective-c
[[VStackManager instance] setDebugLog:YES];
```

### 4.5. Initial SDK
```objective-c
[[VStackManager instance] initial];
```
Sau khi đã thiết lập xong các thông số thì gọi hàm này để initial SDK. Hàm này là bắt buộc để lưu các thiết lập và 
khởi tạo các thành phần của SDK. Chú ý: Hàm chỉ cần gọi 1 lần khi chạy ứng dụng.


### 4.6. Thay đổi file Info.plist
> a. Cho phép ứng dụng nhận tin nhắn, cuộc gọi khi đang chạy ở background

Bổ sung đoạn sau vào file Info.plist (trong dict tag)
```objective-c
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
    <string>voip</string>
</array>
```

> b. Cho phép ứng dụng lấy location qua GPS (tính năng gửi location)

Bổ sung đoạn sau vào file Info.plist (trong dict tag)
```objective-c
<key>NSLocationWhenInUseUsageDescription</key>
<string>Would you like to use your GPS</string>
```

### 4.7. Kết nối và xác thực vào VStack Server
```objective-c
//connect VS
[[VStackManager instance] connectWithVStackUserID:@"YOUR_VSTACK_USER_ID" userCredentials:@"YOUR_USER_CREDENTIALS" fullname:@"NAME_FOR_PUSH_NOTIFICATION" completion:^(NSString *authenticatedVStackUserID, NSError *error, BOOL successful) {
    if (successful) {
        NSLog(@"Connect VStack Server Successful: authenticatedVStackUserID : %@", authenticatedVStackUserID);
    }
    else{
        NSLog(@"Connect VStack Server Fail! ResponseCode: %d, Error Message: %@", error.code, [error description]);
    }
}];
```

Parameter:

    YOUR_VSTACK_USER_ID: your user ID on your system, as described above

    YOUR_USER_CREDENTIALS: can be your password, token on your system. VStack will not use this information. It's forwared to your server to authenticate your user

    NAME_FOR_PUSH_NOTIFICATION: optional, used to display on push notification

Quy trình xác thực giữa ứng dụng của bạn (VStack SDK), VStack server và server của bạn được mô tả ở bước 3.

# 5. Thực hiện các hàm delegate của VStack SDK
### 5.1. VSUserInfoDelegate
> a. Yêu cầu thông tin 1 số user
```objective-c
- (void) vsRequestUserInfo: (NSArray *) vStackUserIDs withTarget: (int) target;
```
Hàm này được VStack SDK gọi để thông báo rằng SDK cần lấy thông tin của những người nằm trong mảng: listVStackUserIDs.


Lúc này bạn có thể lấy thông tin về các user này trên nội bộ client (nếu có sẵn) hoặc lấy trên server của bạn, sau đó cần trả thông tin cho VStack SDK bằng cách gọi hàm: 
```objective-c
[[VStackManager instance] sendUserInfoToVStack:listUserInfo withTarget:purpose.intValue];
```
Xem code mẫu tại đây: https://github.com/vstacksdk/ios-sdk-documentation/blob/master/SampleCode/sample%20method/vsRequestUserInfo.m

> b. Yêu cầu danh sách user của bạn 
```objective-c
- (NSArray *) vsRequestFriendList;
```

VStack SDK sẽ gọi hàm này để lấy về danh sách bạn bè (chẳng hạn lúc cần tạo group mới, lúc thêm 1 người dùng vào 1 group)

Xem code mẫu tại đây: https://github.com/vstacksdk/ios-sdk-documentation/blob/master/SampleCode/sample%20method/vsRequestFriendList.m

> c. Yêu cầu 1 controller để hiển thị thông tin của user
```objective-c
- (UIViewController *) vsRequestUserInfoController:(vStackUser *)user withVStackUserID:(NSString *)vStackUserID;
```

VStack SDK sẽ gọi hàm này để lấy về UIViewController để hiển thị thông tin của user.

Xem code mẫu tại đây: https://github.com/vstacksdk/ios-sdk-documentation/blob/master/SampleCode/sample%20method/vsRequestUserInfoController.m

### 5.2. VSCallDelegate
```objective-c
- (void) vsJustFinishCall: (NSDictionary *) callInfo;
```
Hàm này VStack SDK gọi để thông báo cuộc gọi kết thúc.

### 5.3. VSChatDelegate

> a. Yêu cầu navigation controller
```objective-c
- (UINavigationController *) vsRequestNavigationToPushChatController;
```

Hàm này VStack SDK gọi để lấy về UINavigationController dùng để push ChatController khi mà người dùng nhấn vào In-app Notification

<!--![In-app Notification](http://azstack.com/docs/static/FakeNotification.png "In-app Notification")-->

hoặc khi tạo group xong.

> b. Thông báo số tin nhắn chưa đọc thay đổi
```objective-c
- (void) vsUpdateUnreadMessageCount: (int) unreadCount;
```
Hàm này VStack SDK gọi để thông báo khi số tin nhắn chưa đọc thay đổi.



# 6. Tạo 1 cửa sổ chat (ChatController)
```objective-c
UIViewController* chatController =  [[VStackManager instance] chatWithUser:self.contact.username withUserInfo:@{@"name": self.contact.fullname}];
```

```objective-c
- (UIViewController *) chatWithUser: (NSString *) vStackUserID;
```
Bạn gọi hàm này để tạo 1 chat controller (cửa sổ chat với 1 user).

Trong trường hợp bạn muốn gọi controller để lựa chọn user thì gọi:
```objective-c
[[VStackManager instance] createChat11];
```
Controller này sẽ lấy danh sách user từ VSUserInfoDelegate 

# 7. Gọi điện đến 1 người

Audio call:

```objective-c
[[VStackManager instance] callWithUser:self.contact.username withUserInfo:@{@"name": self.contact.fullname}];
```
```objective-c
[[[VStackManager instance] callWithUser: vStackUserID];
```

Video call:

```objective-c
[[VStackManager instance] callVideoWithUser:@"user2"];
```

```objective-c
[[VStackManager instance] callVideoWithUser:@"user2" withUserInfo:@{@"name": @"User 2"}];
```

# 8. Tạo chat nhóm
```objective-c
- (UIViewController *) chatWithGroup: (NSArray *) vStackUserIDs withGroupInfo: (NSDictionary *) groupInfo;
```

Truyền vào list vStackUserIDs mà bạn muốn tạo nhóm

Trong trường hợp bạn muốn gọi controller để lựa chọn list vStackUserIDs cho thuận tiện thì gọi hàm:
```objective-c
[[VStackManager instance] createChatGroup];
```

Controller này sẽ lấy list user đầu vào từ VSUserInfoDelegate 

# 9. Push notification
### 9.1. Register for push notification

Đầu tiên bạn phải đăng ký việc gửi push notification cho ứng dụng của bạn, trong hàm:
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
```

thêm đoạn code:
```objective-c
if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
} else {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}
```

### 9.2. Gửi Devicede Token lên cho VSStack server và xử lý push notification / local notification
Xem code mẫu:
```objective-c
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    [[VStackManager instance] registerForRemoteNotificationsWithDeviceToken:deviceToken];
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    if ([identifier isEqualToString:@"declineAction"]){
    } else if ([identifier isEqualToString:@"answerAction"]){
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {
    [[VStackManager instance] processLocalNotify:notif];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[VStackManager instance] processRemoteNotify:userInfo];
}
```
### 9.3. Xử lý khi người dùng click vào local notification / push notification:
```objective-c
[[VStackManager instance] processRemoteNotify:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
if (locationNotification) {
    [[VStackManager instance] processLocalNotify:locationNotification];
}
```
đoạn code này phải gọi cuối cùng của hàm:
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
```
(trước khi hàm didFinishLaunchingWithOptions return)

### 9.4. Cập nhật tên tài khoản để hiển thị trong notification

VStack cần tên tài khoản của bạn để hiển thị trong các thông báo khi push notification. Vì vậy, mỗi khi bạn cập nhật lại tên tài khoản cần gọi hàm sau để update tên hiển thị mới nhất:

```objective-c
[[VStackManager instance] updateFullnameForPushNotification:@"NEW_NAME"];
```
