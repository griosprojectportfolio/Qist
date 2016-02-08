//
//  UpdateProfileController.swift
//  Qist
//
//  Created by GrepRuby3 on 05/01/16.
//  Copyright © 2016 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import MagicalRecord

class UpdateProfileController : BaseController  {
 
    @IBOutlet var txtCommon: QistTextField?
    var index : Int!

    var datePicker : UIDatePicker!
    var toolbar : UIToolbar!
    var btnBarDone : UIBarButtonItem!
    var btnBarfilex : UIBarButtonItem!
    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "UPDATE"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup befour appear the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after appear the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - API CALL- GET ABOUT US PAGE DATA
    @IBAction func updateProfileButtonTapped(sender: UIButton) {
        
        if !self.txtCommon!.text!.isEmpty
        {
            self.startLoadingIndicatorView()
            let dictParams : NSDictionary = self.getRequestParamsToUpdate()

            self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "user_update", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
                
                    self.stopLoadingIndicatorView()
                    let dictResponse : NSDictionary = responseObject as! NSDictionary
                    let objCustomer : NSDictionary = dictResponse["user"] as! NSDictionary
                    self.setUserLoginSession_AccessToken(objCustomer["access_token"] as! String)
                    self.storeSignupUserInfoInCoreData(objCustomer)
                },
                failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                    self.stopLoadingIndicatorView()
                    self.showErrorMessageOnApiFailure(task!.responseData!, title: "UPDATE!")
            })
        }else {
            self.showErrorPopupWith_title_message("UPDATE!", strMessage: "Please enter valid text to update.")
        }
    }
    
    
    // MARK: -  Login page Common Methods
    
    func storeSignupUserInfoInCoreData(dictData: NSDictionary) {
        let arrData : NSArray = NSArray(object: dictData)
        MagicalRecord.saveWithBlock({ ( context : NSManagedObjectContext!) -> Void in
            User.entityFromArrayInContext( arrData , localContext: context)
            self.showBackNavAlertWith_title_message("UPDATE!", strMessage: "Profile successfully updated on Qist.")
        })
    }
    
    func getRequestParamsToUpdate() -> NSDictionary {
        var dictParams : NSDictionary!
        switch index {
            case 0 : dictParams = ["access_token": self.auth_token, "first_name":self.txtCommon!.text!]
            case 1 : dictParams = ["access_token": self.auth_token, "last_name":self.txtCommon!.text!]
            case 4 : dictParams = ["access_token": self.auth_token, "password":self.txtCommon!.text!]
            case 2 : dictParams = ["access_token": self.auth_token, "dob":self.txtCommon!.text!]
            default : print("None")
        }
        return dictParams
    }
    
    
    // MARK: -  Overrided Methods of BaseController
    override func leftNavBackButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func configureComponentsLayout(){
        // This function use for set layout of components.
        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: "selectedDate:", forControlEvents: UIControlEvents.ValueChanged)
        btnBarDone = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target:self, action: "btnBarDoneTapped")
        btnBarfilex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolbar = UIToolbar(frame: CGRectMake(0,0,self.view.frame.size.width,40))
        toolbar.setItems([btnBarfilex,btnBarDone], animated: true)

        if index == 0 {
            self.txtCommon!.setupTextFieldBasicProperty("icon_username", isSecureEntery: false)
            self.txtCommon?.placeholder = "Enter first name."
        }else if index == 1 {
            self.txtCommon!.setupTextFieldBasicProperty("icon_username", isSecureEntery: false)
            self.txtCommon?.placeholder = "Enter last name."
        }else if index == 4 {
            self.txtCommon!.setupTextFieldBasicProperty("icon_password", isSecureEntery: false)
            self.txtCommon?.placeholder = "Enter new password."
        }else if index == 2 {
            self.txtCommon!.setupTextFieldBasicProperty("icon_dob", isSecureEntery: false)
            self.txtCommon?.placeholder = "Upadte DOB."
            self.txtCommon?.inputView = datePicker
            self.txtCommon?.inputAccessoryView = toolbar
        }

    }
    
    override func assignDataToComponents(){
        // This function use for assign data to components.
    }

    func selectedDate(datePicker:UIDatePicker) {
        txtCommon?.text = NSDate().getDobWithFormate(datePicker)
    }

    func btnBarDoneTapped() {
        txtCommon?.resignFirstResponder()
    }
    
}