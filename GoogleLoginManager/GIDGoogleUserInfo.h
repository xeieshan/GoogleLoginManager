//
//  GIDGoogleUserInfo.h
//  GoogleLoginManager
//
//  Created by Zeeshan Haider on 24/03/2017.
//  Copyright © 2017 <#Project Team#>. All rights reserved.
//

#import <GoogleSignIn/GoogleSignIn.h>

@interface GIDGoogleUserInfo : GIDGoogleUser

@property (nonatomic,strong) GIDGoogleUser *user;

@property (nonatomic,strong) NSString *picture;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *locale;

@end
