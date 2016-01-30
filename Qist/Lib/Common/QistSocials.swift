//
//  QistSocials.swift
//  Qist
//
//  Created by GrepRuby3 on 17/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import Accounts
import Social

let FacebookAppIdKey = "357620804394305"
let FacebookPermissionsKey = ["email"]

protocol facebookDataDelegate{
    func currentFacebookUserData(aDictionary : NSDictionary)
    func failedToGetFacebookUserData(errorMessage : String)
}

protocol twitterDataDelegate{
    func currentTwitterUserData(aDictionary : NSDictionary)
    func failedToGettwitterUserData(errorMessage : String)
}

class QistSocials : NSObject {
    
    var acAcount : ACAccount = ACAccount()
    var accountStore : ACAccountStore  = ACAccountStore()
    var okFacebook :Bool = SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)
    var okTwitter :Bool = SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)

    var fbDelegate : facebookDataDelegate?
    var twDelegate : twitterDataDelegate?
    
    // MARK: - Facebook User's basic Information
    func getFacebookUsersBasicInformation(){
        
        print(SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook))
        
        /*if !SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            
            self.fbDelegate?.failedToGetFacebookUserData("The accounts must be setup under settings. After login from settings again tapped this button to connect through Facebook via app.")
            
        }else{*/
            
            let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
            print(accountType)
            let postingOptions = [ACFacebookAppIdKey: FacebookAppIdKey ,ACFacebookPermissionsKey: FacebookPermissionsKey]
            
            accountStore.requestAccessToAccountsWithType(accountType, options: postingOptions as [NSObject : AnyObject] , completion: { (success, error) -> Void in
                
                if success {
                    let options = [ACFacebookAppIdKey: FacebookAppIdKey ,ACFacebookPermissionsKey: FacebookPermissionsKey]
                    self.accountStore.requestAccessToAccountsWithType(accountType, options:options as [NSObject : AnyObject], completion: { (success, error) -> Void in
                        let accountsArray = self.accountStore.accountsWithAccountType(accountType) as NSArray
                        self.acAcount = accountsArray.lastObject as! ACAccount
                        if accountsArray.count > 0 {
                            let feedURL = NSURL(string:"https://graph.facebook.com/me")
                            let postRequest = SLRequest(forServiceType: SLServiceTypeFacebook, requestMethod:SLRequestMethod.GET, URL: feedURL, parameters:nil)
                            postRequest.account = self.acAcount
                            postRequest.performRequestWithHandler({ (responseData:NSData!, urlResponse:NSHTTPURLResponse!,error:NSError!) -> Void in
                                if error != nil {
                                    self.fbDelegate?.failedToGetFacebookUserData("There is some authentication problem.")
                                }else {
                                    do {
                                        let dictUser : AnyObject = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves)
                                        self.fbDelegate?.currentFacebookUserData(dictUser as! NSDictionary)
                                        
                                    }catch{
                                        self.fbDelegate?.failedToGetFacebookUserData("failed to get Facebook user info, please try again.")
                                    }
                                }
                            })
                            
                        }else{
                            print(error, terminator: "")
                        }
                        
                    })
                }else{
                   self.fbDelegate?.failedToGetFacebookUserData("The accounts must be setup under settings. After login from settings again tapped this button to connect through Facebook via app.")
                }
                
            })
            
        //}
    }
    
    // MARK: - Twitter User's basic Information
    func getTwittweUsersBasicInformation(){
        
        if !SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            
            self.twDelegate?.failedToGettwitterUserData("The accounts must be setup under settings. After login from settings again tapped this button to connect through Twitter via app.")
            
        }else{
            
            let accountType:ACAccountType! = self.accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            self.accountStore.requestAccessToAccountsWithType(accountType, options: nil, completion: { (granted:Bool,error:NSError!) -> Void in
                
                if granted == true{
                    let arrayOfAccounts: NSArray! = self.accountStore.accountsWithAccountType(accountType)
                    
                    if arrayOfAccounts.count > 0{
                        let twitterAccount:ACAccount! = arrayOfAccounts.lastObject as! ACAccount
                        
                        let requestURL:NSURL! = NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")
                        let timelineRequest:SLRequest! = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod:SLRequestMethod.GET, URL: requestURL, parameters:nil)
                        
                        timelineRequest.account = twitterAccount
                        
                        print(timelineRequest.account)
                        
                        timelineRequest.performRequestWithHandler({ (responseData:NSData!,urlResponse:NSHTTPURLResponse!, error:NSError!) -> Void in
                            if error != nil {
                                self.twDelegate?.failedToGettwitterUserData("There is some authentication problem.")
                            }else {
                                do {
                                    let dictUser : AnyObject = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves)
                                    self.twDelegate?.currentTwitterUserData(dictUser as! NSDictionary)
                                    
                                }catch{
                                    self.twDelegate?.failedToGettwitterUserData("failed to get twitter user info, please try again.")
                                }
                            }
                        })
                    }
                }
                
            })
        }
        
    }
    
}