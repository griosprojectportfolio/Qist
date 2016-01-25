//
//  ForgotPassController.swift
//  Qist
//
//  Created by GrepRuby3 on 16/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import MagicalRecord

class ForgotPassController : BaseController , facebookDataDelegate , twitterDataDelegate , googlePlusDataDelegate {
    
    @IBOutlet var btnCancel: UIButton?
    @IBOutlet var lblForgot: UILabel?
    @IBOutlet var txtRecoveryEmail: QistTextField?
    @IBOutlet var btnRegister: UIButton?
    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.social.fbDelegate = self
        self.social.twDelegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup befour appear the view.
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after appear the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -  Segue methods for Page transition.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Signup" {
            segue.destinationViewController as! SignupController
        }else if segue.identifier == "Scanner" {
            segue.destinationViewController as! ScannerController
        }
    }
    
    // MARK: -  Button Tap Methods
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func signupButtonTapped(sender: UIButton) {
        self.performSegueWithIdentifier("Signup", sender: self)
    }
    
    @IBAction func sendEmailButtonTapped(sender: UIButton) {
        
        let errorMessage : String = isEnteredDataValid()
        
        if errorMessage.isEmpty {
            
            self.startLoadingIndicatorView()
            let dictParams : NSDictionary = ["email": self.txtRecoveryEmail!.text!]
            
            self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "forgot_pass", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
                
                self.stopLoadingIndicatorView()
                let dictTemp : NSDictionary = responseObject as! NSDictionary
                self.showErrorPopupWith_title_message("FORGOT PASSWORD!", strMessage: "Your password reset successfully please check your mail.")
                
                print(dictTemp)
                },
                failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                    self.stopLoadingIndicatorView()
                    self.showErrorMessageOnApiFailure(task!.responseData!, title: "FORGOT PASSWORD!")
            })
        }else{
            self.showErrorPopupWith_title_message("FORGOT PASSWORD!", strMessage: errorMessage)
        }
        
    }
    
    
    // MARK: -  Social Integration Methods
    @IBAction func loginViaFacebookButtonTapped(sender: UIButton) {
        self.startLoadingIndicatorView()
        self.social.getFacebookUsersBasicInformation()
    }
    
    @IBAction func loginViaGooglePlusButtonTapped(sender: UIButton) {
        let googlePlusView = self.storyboard!.instantiateViewControllerWithIdentifier("Google") as! GooglePlus
        googlePlusView.gPlusDelegate = self
        let navController = UINavigationController(rootViewController: googlePlusView)
        self.presentViewController(navController, animated:true, completion: nil)
    }
    
    @IBAction func loginViaTwitterButtonTapped(sender: UIButton) {
        self.startLoadingIndicatorView()
        self.social.getTwittweUsersBasicInformation()
    }
    
    
    
    // MARK: - facebookDataDelegate Delegate Methods
    func currentFacebookUserData(dictResponse:NSDictionary) {
        
        let dictParams : NSDictionary = [ "facebook_id" : dictResponse["id"]! ,"first_name" : dictResponse["first_name"]! , "last_name" : dictResponse["last_name"]!, "email" : dictResponse["email"]! ]
        
        self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "connect_facebook", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.storeUserInfoInCoreData(dictResponse, isLoginVia:"Facebook")
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "Facebook!")
        })
    }
    
    func failedToGetFacebookUserData(errorMessage:String) {
        self.stopLoadingIndicatorView()
        self.showErrorPopupWith_title_message("Facebook", strMessage: errorMessage)
    }
    
    
    
    // MARK: - twitterDataDelegate Delegate Methods
    func currentTwitterUserData(dictResponse:NSDictionary) {
        
        let arrName = dictResponse["name"]!.componentsSeparatedByString(" ")
        let strFirstname : String = arrName.count > 0 ? arrName[0] : ""
        let strLastname : String = arrName.count > 1 ? arrName[1] : ""
        
        let dictParams : NSDictionary = [ "twitter_id":dictResponse["id"]! ,"first_name":strFirstname ,"last_name":strLastname, "email": "" ]
        
        self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "connect_twitter", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.storeUserInfoInCoreData(dictResponse, isLoginVia:"Twitter")
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "Twitter!")
        })
    }
    
    func failedToGettwitterUserData(errorMessage:String) {
        self.stopLoadingIndicatorView()
        self.showErrorPopupWith_title_message("Twitter", strMessage: errorMessage)
    }
    
    
    
    // MARK: - googlePlusDataDelegate Delegate Methods
    func currentGooglePlusUserData(dictResponse:NSDictionary) {
        
        self.startLoadingIndicatorView()
        
        let arrName = dictResponse["name"]!.componentsSeparatedByString(" ")
        let strFirstname : String = arrName.count > 0 ? arrName[0] : ""
        let strLastname : String = arrName.count > 1 ? arrName[1] : ""
        
        let dictParams : NSDictionary = ["googleplus_id" : dictResponse["id"]!, "first_name":strFirstname, "last_name":strLastname, "email" : dictResponse["email"]! ]
        
        self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "connect_googleplus", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.storeUserInfoInCoreData(dictResponse, isLoginVia:"Google Plus")
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "Google Plus!")
        })
    }
    
    func failedToGetGooglePlusUserData(errorMessage:String) {
        self.showErrorPopupWith_title_message("Google Plus", strMessage: errorMessage)
    }
    
    
    
    // MARK: - API CALL- SAVE TO LOCAL DB
    func storeUserInfoInCoreData(dictResponse: NSDictionary ,isLoginVia:String) {
        
        let objCustomer : NSDictionary = dictResponse["customer"] as! NSDictionary
        self.setUserLoginSession_AccessToken(objCustomer["access_token"] as! String)
        let arrData : NSArray = NSArray(object: objCustomer)
        
        MagicalRecord.saveWithBlock({ ( context : NSManagedObjectContext!) -> Void in
            User.entityFromArrayInContext( arrData , localContext: context)
            self.showLoginAlertWithNavigation(isLoginVia)
        })
    }
    
    
    // MARK: - Text Field Delegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    
    // MARK: -  Forgot Password page Common Methods
    func isEnteredDataValid() -> String {
        var strError : String = ""
        if txtRecoveryEmail!.text!.isValidEmailAddress(){
            strError = "Please enter valid Recovery Email Address."
        }
        return strError
    }
    
    func showLoginAlertWithNavigation(strMessage:String){
        dispatch_async(dispatch_get_main_queue()) {
            self.alertQist = UIAlertController.alertWithTitleAndMessage("LOGIN" ,message:"Successfully logged in with \(strMessage)", handler:{(objAlertAction : UIAlertAction!) -> Void in
                self.performSegueWithIdentifier("Scanner", sender: self)
            })
            self.presentViewController(self.alertQist, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        // This function use for set layout of components.
        self.txtRecoveryEmail!.setupTextFieldBasicProperty("login_popup_icon_email", isSecureEntery: false)
        let strRegisterTitle = NSMutableAttributedString(string: "NEW TO QIST? \n REGISTER NOW",attributes: [NSForegroundColorAttributeName : UIColor.whiteColor() , NSFontAttributeName : UIFont.defaultFontOfSize(11.0)])
        strRegisterTitle.addAttribute(NSFontAttributeName, value: UIFont.boldFontOfSize(14.0), range:  NSRange(location:15,length:12))
        btnRegister?.titleLabel?.numberOfLines = 0
        btnRegister?.titleLabel?.textAlignment = .Center
        btnRegister?.setAttributedTitle(strRegisterTitle, forState: UIControlState.Normal)
        
        if isiPhone5 {
            self.btnCancel?.frame = CGRectMake(self.btnCancel!.frame.origin.x + 2, self.btnCancel!.frame.origin.y ,self.btnCancel!.frame.size.width , self.btnCancel!.frame.size.height)
        }else if isiPhone6plus {
            self.btnCancel?.frame = CGRectMake(self.btnCancel!.frame.origin.x, self.btnCancel!.frame.origin.y - 2,self.btnCancel!.frame.size.width , self.btnCancel!.frame.size.height)
        }else if isiPad {
            self.txtRecoveryEmail?.frame = CGRectMake(self.txtRecoveryEmail!.frame.origin.x + 15, self.txtRecoveryEmail!.frame.origin.y,self.txtRecoveryEmail!.frame.size.width - 30, self.txtRecoveryEmail!.frame.size.height)
            self.btnCancel?.frame = CGRectMake(self.btnCancel!.frame.origin.x - 15, self.btnCancel!.frame.origin.y - 6,self.btnCancel!.frame.size.width , self.btnCancel!.frame.size.height)
        }
    }
    
}

