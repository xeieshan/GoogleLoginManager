//
//  GoogleLoginManagerSwift.swift
//  GoogleLoginManager
//
//  Created by <#Developer Name#> on 21/03/2017.
//  Copyright © 2017 <#Project Team#>. All rights reserved.
//

import Foundation
import GoogleSignIn
import Google

protocol GoogleLoginManagerDelegate {
    func didLogin();
    func didLogout();
    func didDisconnect();
}
class GoogleLoginManager : NSObject,GIDSignInDelegate,GIDSignInUIDelegate {
    
    var delegate: GoogleLoginManagerDelegate?
    var loggedUser: GIDGoogleUser?
    
    static let sharedLoginManager: GoogleLoginManager = GoogleLoginManager()
    
    class func handleURL(url: NSURL, sourceApplication: String, annotation: AnyObject) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL!, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func tryLoginWith(delegate: GoogleLoginManagerDelegate) {
        self.delegate = delegate
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        if configureError != nil {
            print("Error configuring the Google context: \(configureError)")
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func tryLogout() {
        GIDSignIn.sharedInstance().disconnect()
    }
    
    // MARK: -
    // MARK: GIDSignInDelegate
    // MARK: -
    
    // The sign-in flow has finished and was successful if |error| is |nil|.
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations on signed in user here.
        print("name=\(user.profile.name)")
        print("accessToken=\(user.authentication.accessToken)")
        GoogleLoginManager.sharedLoginManager.loggedUser = user
        if GIDSignIn.sharedInstance().currentUser.authentication == nil {
            if (self.delegate != nil) {
                self.delegate?.didLogout()
            }
        } else {
            if (self.delegate != nil) {
                self.delegate?.didLogin()
            }
            
        }
    }
    
    
    
    // This callback is triggered after the disconnect call that revokes data
    // access to the user's resources has completed.
    
    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        // Perform any operations when the user disconnects from app here.
        print("didDisconnectWithUser")
        if (self.delegate != nil) {
            self.delegate?.didDisconnect()
        }
    }
    
    // MARK: -
    // MARK: GIDSignInUIDelegate
    // MARK: -
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    // The sign-in flow has finished selecting how to proceed, and the UI should no longer display
    // a spinner or other "please wait" element.
    public func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    
    // If implemented, this method will be invoked when sign in needs to display a view controller.
    // The view controller should be displayed modally (via UIViewController's |presentViewController|
    // method, and not pushed unto a navigation controller's stack.
    public func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        let vc: UIViewController = (self.delegate as? UIViewController)!
        vc.present(viewController, animated: true, completion: nil)
    }
    
    
    // If implemented, this method will be invoked when sign in needs to dismiss a view controller.
    // Typically, this should be implemented by calling |dismissViewController| on the passed
    // view controller.
    public func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        let vc: UIViewController = (self.delegate as? UIViewController)!
        vc.dismiss(animated: true, completion: nil)
    }
    
}

