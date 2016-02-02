//
//  LoginController.swift
//  Qist
//
//  Created by GrepRuby3 on 16/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import MagicalRecord

class LoginController : BaseController , facebookDataDelegate , twitterDataDelegate , googlePlusDataDelegate {
    
    @IBOutlet var btnIsRemember: UIButton?
    @IBOutlet var txtEmail: QistTextField?
    @IBOutlet var txtPassword: QistTextField?
    
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
        self.view.removeGestureRecognizer(self.rightSwipeGestureRecognizer)
        // Navigate user to Scanner page
        if !self.auth_token.isEmpty {
            self.performSegueWithIdentifier("Scanner", sender: self)
        }else{
            self.getAndSetLastLogedInUser("", isSetUser : false)
        }
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
        }else if segue.identifier == "ForgotPass" {
            segue.destinationViewController as! ForgotPassController
        }else if segue.identifier == "Scanner" {
            segue.destinationViewController as! ScannerController
        }
    }
    
    
    
    // MARK: -  Button Tap Methods
    @IBAction func signupButtonTapped(sender: UIButton) {
        self.performSegueWithIdentifier("Signup", sender: self)
    }
    
    @IBAction func forgotPassButtonTapped(sender: UIButton) {
        self.performSegueWithIdentifier("ForgotPass", sender: self)
    }
    
    @IBAction func isRememberButtonTapped(sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            self.btnIsRemember?.setBackgroundImage(UIImage(named: "checkbox_tick"), forState: UIControlState.Normal)
        }else {
            sender.tag = 0
            self.btnIsRemember?.setBackgroundImage(UIImage(named: "checkbox"), forState: UIControlState.Normal)
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
        
        let dictParams : NSDictionary = facebookUserDataChecks(dictResponse)//[ "facebook_id" : dictResponse["id"]! ,"first_name" : dictResponse["first_name"]! , "last_name" : dictResponse["last_name"]!, "email" : dictResponse["email"]! ]
        
        print(dictParams)

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
        print(dictResponse)
        
        let dictParams : NSDictionary = twitterUserDataChecks(dictResponse)

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
        let dictParams : NSDictionary = googlePlusUserDataChecks(dictResponse)

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
    func postEmailAddressAndPasswordOnServer(){
        
        let errorMessage : String = isEnteredDataValid()
        
        if errorMessage.isEmpty {
            
            if self.btnIsRemember?.tag == 1 {
                self.getAndSetLastLogedInUser(self.txtEmail!.text!, isSetUser: true)
            }else {
                self.getAndSetLastLogedInUser("", isSetUser : true)
            }
            
            self.startLoadingIndicatorView()
            let dictParams : NSDictionary = ["user_name": self.txtEmail!.text! , "password" : self.txtPassword!.text!]
            
            self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "user_login", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
                
                    self.stopLoadingIndicatorView()
                    let dictResponse : NSDictionary = responseObject as! NSDictionary
                    self.storeUserInfoInCoreData(dictResponse, isLoginVia: dictParams["user_name"] as! String)
                    self.resetLoginPageContents()
                },
                failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                    self.stopLoadingIndicatorView()

                    if task!.responseData != nil {
                        self.showErrorMessageOnApiFailure(task!.responseData!, title: "LOGIN!")
                    }else{
                        self.showErrorPopupWith_title_message("", strMessage:"Server request timed out.")
                    }
            })
            
        }else{
            self.showErrorPopupWith_title_message("LOGIN!", strMessage: errorMessage)
        }
    }
    
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
    func textFieldDidBeginEditing(textField: QistTextField) {
        textField.animateCurrentViewUpAndDownSide(true, moveValue: 80, viewController: self)
    }
    
    func textFieldShouldEndEditing(textField: QistTextField) -> Bool {
        textField.animateCurrentViewUpAndDownSide(false, moveValue: 80, viewController: self)
        return true
    }
    
    func textFieldShouldReturn(textField: QistTextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtPassword {
            self.postEmailAddressAndPasswordOnServer()
        }
        return false
    }
    
    
    
    // MARK: -  Login page Common Methods
    func isEnteredDataValid() -> String {
        var strError : String = ""
        if self.txtEmail!.text!.isEmpty {
            strError = "Please enter valid Username."
        }else if self.txtPassword!.text!.isEmpty {
            strError = "Please enter valid Password."
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
    
    func resetLoginPageContents(){
        self.txtEmail?.text = ""
        self.txtPassword?.text = ""
        self.btnIsRemember?.tag = 0
        self.btnIsRemember?.setBackgroundImage(UIImage(named: "checkbox"), forState: UIControlState.Normal)
    }
    
    
    // MARK: -  Remember me Functionality methods
    func getAndSetLastLogedInUser(strUserName: String ,isSetUser: Bool){
        if isSetUser {
            self.remember_user = strUserName
        }else {
            self.txtEmail?.text = self.remember_user
        }
    }
    
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        
        // This function use for set layout of components.
        self.txtEmail!.setupTextFieldBasicProperty("icon_username", isSecureEntery: false)
        self.txtPassword!.setupTextFieldBasicProperty("icon_password", isSecureEntery: true)
        
        let strRegisterTitle = NSMutableAttributedString(string: "NEW TO QIST? \n REGISTER NOW",attributes: [NSForegroundColorAttributeName : UIColor.whiteColor() , NSFontAttributeName : UIFont.defaultFontOfSize(11.0)])
        strRegisterTitle.addAttribute(NSFontAttributeName, value: UIFont.boldFontOfSize(14.0), range:  NSRange(location:15,length:12))
        btnRegister?.titleLabel?.numberOfLines = 0
        btnRegister?.titleLabel?.textAlignment = .Center
        btnRegister?.setAttributedTitle(strRegisterTitle, forState: UIControlState.Normal)

        
        if isiPhone4s {
            self.txtEmail?.frame = CGRectMake(self.txtEmail!.frame.origin.x, 185 ,self.txtEmail!.frame.size.width , self.txtEmail!.frame.size.height)
            self.txtPassword?.frame = CGRectMake(self.txtPassword!.frame.origin.x, 230,self.txtPassword!.frame.size.width , self.txtPassword!.frame.size.height)
        }else if isiPhone5 {
            self.txtEmail?.frame = CGRectMake(self.txtEmail!.frame.origin.x, self.txtEmail!.frame.origin.y - 10,self.txtEmail!.frame.size.width , self.txtEmail!.frame.size.height)
            self.txtPassword?.frame = CGRectMake(self.txtPassword!.frame.origin.x, self.txtPassword!.frame.origin.y - 5,self.txtPassword!.frame.size.width , self.txtPassword!.frame.size.height)
        }
        
    }
    
    
}

