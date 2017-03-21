//
//  ViewController.m
//  GoogleLoginManager
//
//  Created by <#Project Developer#> on 20/03/2017.
//  Copyright © 2017 <#Project Team#>. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_btnSignOut setEnabled:![[[GoogleLoginManager sharedLoginManager] loggedUser] authentication]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSignIn_Pressed:(UIButton *)sender {
    [[GoogleLoginManager sharedLoginManager] tryLoginWith:self];
}

- (IBAction)btnSignOut_Pressed:(UIButton *)sender {
   [[GoogleLoginManager sharedLoginManager] tryLogout];
}
- (void)didLogin{
    GIDGoogleUser *user = [[GoogleLoginManager sharedLoginManager] loggedUser];
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = @"http://github.com/xeieshan";//user.profile.email;
    // ...
    [_lblStatus setText:[NSString stringWithFormat:@"%@ %@ %@ %@", fullName,givenName,familyName,email]];
    [_btnSignOut setEnabled:true];
}
- (void)didLogout {
    [_btnSignOut setEnabled:false];
    [_lblStatus setText:@""];
}
- (void)didDisconnect{
    [_btnSignOut setEnabled:false];
    [_lblStatus setText:@""];
}

@end
