//
//  GoogleLoginManager.h
//  GoogleLoginManager
//
//  Created by <#Project Developer#> on 20/03/2017.
//  Copyright © 2017 <#Project Team#>. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google/SignIn.h>
#import "AppDelegate.h"

@protocol GoogleLoginManagerDelegate <NSObject>
 
- (void)didLogin;
- (void)didLogout;
- (void)didDisconnect;

@end

@interface GoogleLoginManager : NSObject<
GIDSignInUIDelegate,
GIDSignInDelegate
>

@property (nonatomic, assign) id<GoogleLoginManagerDelegate> delegate;
@property (nonatomic, strong) GIDGoogleUser *loggedUser;

+ (instancetype)sharedLoginManager;
+ (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (void)tryLoginWith:(id<GoogleLoginManagerDelegate>)delegate;
- (void)tryLogout;

@end
