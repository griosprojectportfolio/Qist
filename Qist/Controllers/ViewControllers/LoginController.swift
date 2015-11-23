//
//  LoginController.swift
//  Qist
//
//  Created by GrepRuby3 on 16/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

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
            self.getAndSetLastLogedInUser([],isSetUser:false)
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
        self.stopLoadingIndicatorView()
        // Save user basic info in database
        self.storeUserInfoInCoreData(dictResponse,isLoginVia:"Facebook")
    }
    
    func failedToGetFacebookUserData(errorMessage:String) {
        self.stopLoadingIndicatorView()
        self.showErrorPopupWith_title_message("Facebook", strMessage: errorMessage)
    }

    
    
    // MARK: - twitterDataDelegate Delegate Methods
    func currentTwitterUserData(dictResponse:NSDictionary) {
        self.stopLoadingIndicatorView()
        let dictData : NSDictionary = [ "id" : dictResponse["id_str"] as! String ,"first_name" : dictResponse["name"] as! String ,
            "last_name" : dictResponse["name"] as! String , "email" : "" , "birthday" : "", "gender" : "" ]
        // Save user basic info in database
        self.storeUserInfoInCoreData(dictData,isLoginVia:"Twitter")
    }
    
    func failedToGettwitterUserData(errorMessage:String) {
        self.stopLoadingIndicatorView()
        self.showErrorPopupWith_title_message("Twitter", strMessage: errorMessage)
    }
    
    
    
    // MARK: - googlePlusDataDelegate Delegate Methods
    func currentGooglePlusUserData(dictResponse:NSDictionary) {
        let dictData : NSDictionary = [ "id" : dictResponse["id"] as! String ,"first_name" : dictResponse["name"] as! String ,
            "last_name" : dictResponse["name"] as! String , "email" : dictResponse["email"] as! String ,
            "birthday" : "", "gender" : dictResponse["gender"] as! String ]
        // Save user basic info in database
        self.storeUserInfoInCoreData(dictData,isLoginVia:"Google Plus")
    }
    
    func failedToGetGooglePlusUserData(errorMessage:String) {
        self.showErrorPopupWith_title_message("Google Plus", strMessage: errorMessage)
    }
    
    
    
    
    // MARK: - API CALL- SAVE TO LOCAL DB
    func postEmailAddressAndPasswordOnServer(){
        
        let errorMessage : String = isEnteredDataValid()
        
        if errorMessage.isEmpty {
            
            if self.btnIsRemember?.tag == 1 {
                self.getAndSetLastLogedInUser([["user_name" : self.txtEmail!.text! , "password" : self.txtPassword!.text!]],isSetUser:true)
            }
            
            self.startLoadingIndicatorView()
            let dictParams : NSDictionary = ["email": self.txtEmail!.text! , "password" : self.txtPassword!.text!]
            
            self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "login", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
                
                    self.stopLoadingIndicatorView()
                    let dictTemp : NSDictionary = responseObject as! NSDictionary
                    let dictResponse : NSDictionary = dictTemp["user"] as! NSDictionary
                    self.setUserLoginSession_AccessToken( dictResponse["access_token"] as! String)
                    self.showLoginAlertWithNavigation(self.txtEmail!.text!)
                    self.resetLoginPageContents()

                },
                failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                    self.stopLoadingIndicatorView()
            })
        }else{
            self.showErrorPopupWith_title_message("LOGIN", strMessage: errorMessage)
        }
    }
    
    func storeUserInfoInCoreData(dictData: NSDictionary ,isLoginVia:String) {
        let arrData : NSArray = NSArray(object: dictData)
        MagicalRecord.saveWithBlock({ ( context : NSManagedObjectContext!) -> Void in
            User.entityFromArrayInContext( arrData , localContext: context)
            self.setUserLoginSession_AccessToken("XYZ")
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
            self.alertQist = UIAlertController.alertWithTitleAndMessage("Login" ,message:"Successfully logged in with \(strMessage)", handler:{(objAlertAction : UIAlertAction!) -> Void in
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
    func getAndSetLastLogedInUser(arrUserInfo: NSArray ,isSetUser: Bool){
        if isSetUser {
            MagicalRecord.saveWithBlock({ ( context : NSManagedObjectContext!) -> Void in
                SavedUser.entityFromArrayInContext( arrUserInfo, localContext: context)
            })
        }else{
            let arrUser = SavedUser.MR_findAll() as NSArray
            if arrUser.count > 0 {
                let objUser : SavedUser = arrUser[0] as! SavedUser
                self.txtEmail?.text = objUser.user_name
                self.txtPassword?.text = objUser.password
            }
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

