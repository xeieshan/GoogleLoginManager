//
//  ViewController.h
//  GoogleLoginManager
//
//  Created by <#Project Developer#> on 20/03/2017.
//  Copyright © 2017 <#Project Team#>. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleLoginManager.h"

@interface ViewController : UIViewController <GoogleLoginManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSignOut;
@property (weak,nonatomic) IBOutlet UILabel *lblStatus;
@end

