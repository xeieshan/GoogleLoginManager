//
//  GoogleLoginManager.m
//  GoogleLoginManager
//
//  Created by <#Project Developer#> on 20/03/2017.
//  Copyright © 2017 <#Project Team#>. All rights reserved.
//

#import "GoogleLoginManager.h"

@implementation GoogleLoginManager

static GoogleLoginManager *_sharedLoginManager = nil;

+ (instancetype)sharedLoginManager {
    if (!_sharedLoginManager) {
        _sharedLoginManager = [[GoogleLoginManager alloc] init];
    }
    return _sharedLoginManager;
}

+ (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}
- (void)tryLoginWith:(id<GoogleLoginManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    if (configureError != nil) {
        NSLog(@"Error configuring the Google context: %@", configureError);
    }
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].scopes = @[@"https://www.googleapis.com/auth/plus.me",@"https://www.googleapis.com/auth/plus.stream.read"];
    [[GIDSignIn sharedInstance] signIn];
    
//    [[UIApplication sharedApplication] keyWindow] setYser
}
- (void)tryLogout{
    [[GIDSignIn sharedInstance] disconnect];
}
#pragma mark -
#pragma mark GIDSignInDelegate
#pragma mark -

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    if ([GIDSignIn sharedInstance].currentUser.authentication == nil) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLogout)]) {
            [self.delegate didLogout];
        }
    } else {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
        
        // Perform any operations on signed in user here.
        NSLog(@"name=%@", user.profile.name);
        NSLog(@"accessToken=%@", user.authentication.accessToken);
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.maxConcurrentOperationCount = 2;
        
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            NSString *gplusapi = [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v3/userinfo?access_token=%@", user.authentication.accessToken];
            NSURL *url = [NSURL URLWithString:gplusapi];
            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.];
            urlRequest.HTTPMethod = @"GET";
            [urlRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            
            NSURLSession *urlSession = [NSURLSession sharedSession];
            [[urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
                NSError *e = nil;
                NSDictionary *userData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
                
                if (!userData) {
                    NSLog(@"Error parsing JSON: %@", e);
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didFailWithError:)]) {
                        [self.delegate didFailWithError:e];
                    }
                } else {
                    NSString *picture = userData[@"picture"];
                    NSString *gender = userData[@"gender"];
                    NSString *locale = userData[@"locale"];
                    
                    GIDGoogleUserInfo *infoUser = [[GIDGoogleUserInfo alloc] init];
                    infoUser.user = user;
                    infoUser.locale = locale;
                    infoUser.picture = picture;
                    infoUser.gender = gender;
                    [[GoogleLoginManager sharedLoginManager] setLoggedUser:infoUser];
                    dispatch_async(dispatch_get_main_queue(), ^{ 
                        if (self.delegate && [self.delegate respondsToSelector:@selector(didLogin)]) {
                            [self.delegate didLogin];
                        }
                    });
                }
                
            }] resume];
        }];
        [queue addOperation:blockOperation];
    }
    
}

// This callback is triggered after the disconnect call that revokes data
// access to the user's resources has completed.
- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    NSLog(@"didDisconnectWithUser");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDisconnect)] && !error) {
        [self.delegate didDisconnect];
    }
}

#pragma mark -
#pragma mark GIDSignInUIDelegate
#pragma mark -

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //  [myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    UIViewController *vc = (UIViewController*)self.delegate;
    [vc presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    UIViewController *vc = (UIViewController*)self.delegate;
    [vc dismissViewControllerAnimated:YES completion:nil];
}

@end
