//
//  SignupController.swift
//  Qist
//
//  Created by GrepRuby3 on 16/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import MagicalRecord

class SignupController : BaseController {
    
    @IBOutlet var txtFirstName: QistTextField?
    @IBOutlet var txtLastName: QistTextField?
    @IBOutlet var txtEmailAddress: QistTextField?
    @IBOutlet var txtPassword: QistTextField?
    @IBOutlet var txtRepeatPass: QistTextField?
    @IBOutlet var txtDob: QistTextField?

    @IBOutlet var btnRegister: UIButton?

    var datePicker : UIDatePicker!
    var toolbar : UIToolbar!
    var btnBarDone : UIBarButtonItem!
    var btnBarfilex : UIBarButtonItem!
    
    
    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        if segue.identifier == "Scanner" {
            segue.destinationViewController as! ScannerController
        }
    }
    
    
    // MARK: -  Button Tap Methods
    @IBAction func registerButtonTapped(sender: UIButton) {
        
        let errorMessage : String = isEnteredDataValid()
        
        if errorMessage.isEmpty {
            
            self.alertQist = UIAlertController.confirmAlertWithTwoButtonTitles("Terms of Service", message:"By registering you are agreeing to accept the full terms and conditions of use available here: url: https://qist.co.nz/" , btnTitle1:"I Agree", btnTitle2:"I Don't Agree" , handler: { (objAlertAction : UIAlertAction! ) -> Void in
                
                switch objAlertAction.style {
                case .Default :
                    self.postUserBasicInfoOnServer()
                case .Destructive :
                    self.navigationController?.popViewControllerAnimated(true)
                case .Cancel :
                    print("Cancel Button")
                }
            })
            self.presentViewController(self.alertQist, animated: true, completion: nil)
            
        }else{
            self.showErrorPopupWith_title_message("REGISTER!", strMessage: errorMessage)
        }
        
    }
    
    
    
    // MARK: - API CALL- Post user info to sign up
    
    func postUserBasicInfoOnServer(){
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = [ "first_name": self.txtFirstName!.text! ,"last_name" : self.txtLastName!.text!,"dob" : self.txtDob!.text! ,
            "email": self.txtEmailAddress!.text! ,"password" : self.txtPassword!.text! ,"confirm_password" : self.txtRepeatPass!.text! ,
            "longitude" : self.longitude ,"latitude" : self.latitude]
        
        self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "user_signup", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                let objCustomer : NSDictionary = dictResponse["customer"] as! NSDictionary
                self.setUserLoginSession_AccessToken(objCustomer["access_token"] as! String)
                self.storeSignupUserInfoInCoreData(objCustomer)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                if task!.responseData != nil {
                   self.showErrorMessageOnApiFailure(task!.responseData!, title: "REGISTER!")
                }else{
                    self.showErrorPopupWith_title_message("", strMessage:"Server request timed out.")
                }
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
        return false
    }
    
    
    // MARK: -  Sign up page Common Methods
    func isEnteredDataValid() -> String {
        var strError : String = ""
        if txtFirstName?.text == "" {
            strError = "Please enter first name."
        }else if txtLastName?.text == "" {
            strError = "Please enter last name."
        }else if txtEmailAddress!.text!.isValidEmailAddress(){
            strError = "Please enter valid Email Address."
        }else if txtPassword?.text == "" {
            strError = "Please enter password."
        }else if txtRepeatPass?.text == "" {
            strError = "Please enter repeat password."
        }else if txtPassword?.text != txtRepeatPass?.text {
            strError = "Password and repeat password doesn't match."
        }else if txtDob?.text == "" {
            strError = "Please enter DOB."
        }
        return strError
    }
    
    func storeSignupUserInfoInCoreData(dictData: NSDictionary) {
        let arrData : NSArray = NSArray(object: dictData)
        MagicalRecord.saveWithBlock({ ( context : NSManagedObjectContext!) -> Void in
            User.entityFromArrayInContext( arrData , localContext: context)
            self.showAlertOnSignUpSuccess("Successfully registered on Qist.")
        })
    }
    
    func showAlertOnSignUpSuccess(strMessage:String){
        dispatch_async(dispatch_get_main_queue()) {
            self.alertQist = UIAlertController.alertWithTitleAndMessage("REGISTER" ,message: strMessage, handler:{(objAlertAction : UIAlertAction!) -> Void in
                self.performSegueWithIdentifier("Scanner", sender: self)
            })
            self.presentViewController(self.alertQist, animated: true, completion: nil)
        }
    }
    
    
    // MARK: -  Overrided Methods of BaseController
    
    override func configureComponentsLayout(){

        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: "selectedDate:", forControlEvents: UIControlEvents.ValueChanged)
        btnBarDone = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target:self, action: "btnBarDoneTapped")
        btnBarfilex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolbar = UIToolbar(frame: CGRectMake(0,0,self.view.frame.size.width,40))
        toolbar.setItems([btnBarfilex,btnBarDone], animated: true)

        // This function use for set layout of components.
        self.txtFirstName!.setupTextFieldBasicProperty("icon_username", isSecureEntery: false)
        self.txtLastName!.setupTextFieldBasicProperty("icon_username", isSecureEntery: false)
        self.txtEmailAddress!.setupTextFieldBasicProperty("icon_email", isSecureEntery: false)
        self.txtPassword!.setupTextFieldBasicProperty("icon_password", isSecureEntery: true)
        self.txtRepeatPass!.setupTextFieldBasicProperty("icon_password", isSecureEntery: true)
        self.txtDob!.setupTextFieldBasicProperty("icon_dob", isSecureEntery: false)
        self.txtDob?.inputView = datePicker
        self.txtDob?.inputAccessoryView = toolbar
        
        if isiPhone4s {
            self.txtFirstName?.frame = CGRectMake(self.txtFirstName!.frame.origin.x, self.txtFirstName!.frame.origin.y - 10, self.txtFirstName!.frame.size.width, self.txtFirstName!.frame.size.height)
            self.txtLastName?.frame = CGRectMake(self.txtLastName!.frame.origin.x, self.txtLastName!.frame.origin.y , self.txtLastName!.frame.size.width, self.txtLastName!.frame.size.height)

            self.txtDob?.frame = CGRectMake(self.txtDob!.frame.origin.x, self.txtDob!.frame.origin.y + 10 , self.txtDob!.frame.size.width, self.txtDob!.frame.size.height)

            self.txtEmailAddress?.frame = CGRectMake(self.txtEmailAddress!.frame.origin.x, self.txtEmailAddress!.frame.origin.y + 20, self.txtEmailAddress!.frame.size.width, self.txtEmailAddress!.frame.size.height)
            self.txtPassword?.frame = CGRectMake(self.txtPassword!.frame.origin.x, self.txtPassword!.frame.origin.y + 30, self.txtPassword!.frame.size.width, self.txtPassword!.frame.size.height)
            self.txtRepeatPass?.frame = CGRectMake(self.txtRepeatPass!.frame.origin.x, self.txtRepeatPass!.frame.origin.y + 40, self.txtRepeatPass!.frame.size.width, self.txtRepeatPass!.frame.size.height)
            
            self.btnRegister?.frame = CGRectMake(self.btnRegister!.frame.origin.x, self.btnRegister!.frame.origin.y + 33, self.btnRegister!.frame.size.width, self.btnRegister!.frame.size.height)
            
        }else if isiPhone5 {
            
            self.txtFirstName?.frame = CGRectMake(self.txtFirstName!.frame.origin.x, self.txtFirstName!.frame.origin.y - 5, self.txtFirstName!.frame.size.width, self.txtFirstName!.frame.size.height)
            self.txtLastName?.frame = CGRectMake(self.txtLastName!.frame.origin.x, self.txtLastName!.frame.origin.y , self.txtLastName!.frame.size.width, self.txtLastName!.frame.size.height)

            self.txtDob?.frame = CGRectMake(self.txtDob!.frame.origin.x, self.txtDob!.frame.origin.y+5, self.txtDob!.frame.size.width, self.txtDob!.frame.size.height)


            self.txtEmailAddress?.frame = CGRectMake(self.txtEmailAddress!.frame.origin.x, self.txtEmailAddress!.frame.origin.y + 10, self.txtEmailAddress!.frame.size.width, self.txtEmailAddress!.frame.size.height)
            self.txtPassword?.frame = CGRectMake(self.txtPassword!.frame.origin.x, self.txtPassword!.frame.origin.y + 15, self.txtPassword!.frame.size.width, self.txtPassword!.frame.size.height)
            self.txtRepeatPass?.frame = CGRectMake(self.txtRepeatPass!.frame.origin.x, self.txtRepeatPass!.frame.origin.y + 20, self.txtRepeatPass!.frame.size.width, self.txtRepeatPass!.frame.size.height)
            
            self.btnRegister?.frame = CGRectMake(self.btnRegister!.frame.origin.x, self.btnRegister!.frame.origin.y + 20, self.btnRegister!.frame.size.width, self.btnRegister!.frame.size.height)
        }
    }

    func selectedDate(datePicker:UIDatePicker) {
        txtDob?.text = NSDate().getDobWithFormate(datePicker)
    }

    func btnBarDoneTapped() {
        txtDob?.resignFirstResponder()
    }
    
}

