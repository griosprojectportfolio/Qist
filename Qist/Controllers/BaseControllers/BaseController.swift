//
//  BaseController.swift
//  Qist
//
//  Created by GrepRuby3 on 16/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

let isiPhone4s     =   UIScreen.mainScreen().bounds.size.width == 320 && UIScreen.mainScreen().bounds.size.height == 480
let isiPhone5      =   UIScreen.mainScreen().bounds.size.width == 320 && UIScreen.mainScreen().bounds.size.height == 568
let isiPhone6      =   UIScreen.mainScreen().bounds.size.width == 375
let isiPhone6plus  =   UIScreen.mainScreen().bounds.size.width == 414
let isiPad         =   UIScreen.mainScreen().bounds.size.width == 768.0 || UIScreen.mainScreen().bounds.size.width == 1024.0


class BaseController: UIViewController , UITextFieldDelegate , leftPanelDelegate , locationAuthorizationDelegate {
    
    
    var sharedApi : ApiClient!
    var activityIndicator : ActivityIndicatorView!
    var alertQist : UIAlertController!
    let social : QistSocials = QistSocials()
    var leftView : LeftPanelView!
    var rightSwipeGestureRecognizer : UISwipeGestureRecognizer!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let longitude = "-97" //QistLocationManager.sharedManager.currentLocation.longitude
    let latitude = "27" //QistLocationManager.sharedManager.currentLocation.latitude
    let radius = "100"
    var objUser : User!

    let btnBackNav: UIButton = UIButton(type: UIButtonType.Custom)
    let btnBackLogo: UIButton = UIButton(type: UIButtonType.Custom)

    
    var auth_token : String {
        get {
            var strAuthToken : String = ""
            if(NSUserDefaults.standardUserDefaults().objectForKey("auth_token") != nil){
                strAuthToken = NSUserDefaults.standardUserDefaults().objectForKey("auth_token") as! String
            }
            return strAuthToken
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "auth_token")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var remember_user : String {
        get {
            var strUserName : String = ""
            if(NSUserDefaults.standardUserDefaults().objectForKey("remember_user") != nil){
                strUserName = NSUserDefaults.standardUserDefaults().objectForKey("remember_user") as! String
            }
            return strUserName
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "remember_user")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    // MARK: - View Related Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addLeftNavigationItemOnView()
        self.initializeComponents()
        self.configureComponentsLayout()
        self.addRightSwipeGestureOnCurrentView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional before appear the view.
        self.navigationController?.navigationBar.hidden = false
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after appear the view.
        let isAssignable = isAssignDataToComponents()
        if isAssignable {
            self.assignDataToComponents()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation bar and there actions.
    func addLeftNavigationItemOnView(){
        
        btnBackNav.frame = CGRectMake(-10, 0, 32, 32)
        btnBackNav.setImage(UIImage(named:"button_back"), forState: UIControlState.Normal)
        btnBackNav.addTarget(self, action: "leftNavBackButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        btnBackLogo.frame = CGRectMake(20, 0, 32, 32)
        btnBackLogo.setImage(UIImage(named:"top_bar_qist_logo"), forState: UIControlState.Normal)
        btnBackLogo.addTarget(self, action: "leftNavBackButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let backView : UIView = UIView(frame: CGRectMake(0, 0, 77, 32))
        backView.addSubview(btnBackNav)
        backView.addSubview(btnBackLogo)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:backView)
    }
    
    func leftNavBackButtonTapped(sender: UIButton) {
        if !self.auth_token.isEmpty {
            self.leftView.toggleLeftPanel(self)
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    
    // MARK: - Base Class Common Methods.
    func setUserLoginSession_AccessToken(token:String){
        self.auth_token = token
    }
    
    func addRightSwipeGestureOnCurrentView(){
        self.rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "leftNavBackButtonTapped:")
        self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(self.rightSwipeGestureRecognizer)
    }
    
    
    // MARK: - API CALLS - Common server call Methods.
    
    func setStoreAsFavourites(dictParams : NSDictionary) {
        
        self.startLoadingIndicatorView()
        
        self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "set_favourite_store", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.showErrorPopupWith_title_message("FAVOURITE!", strMessage:dictResponse["error"] as! String)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "FAVOURITE!")
        })
    }
    
    func setStoreAsUnFavourites(dictParams : NSDictionary) {
        
        self.startLoadingIndicatorView()
        
        self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "set_unfavourite_store", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.showErrorPopupWith_title_message("UNFAVOURITE!", strMessage:dictResponse["error"] as! String)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "UNFAVOURITE!")
        })
    }
    
    func addProductToWishLists() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token, "product_id": "0"]
        
        self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "add_product_to_wishlist", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
            self.stopLoadingIndicatorView()
            let dictResponse : NSDictionary = responseObject as! NSDictionary
            print(dictResponse)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "ADD PRODUCT!")
        })
    }
    
    func removeProductFromWishLists() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token, "product_id": "0"]
        
        self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "remove_product_from_wishlist", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
            self.stopLoadingIndicatorView()
            let dictResponse : NSDictionary = responseObject as! NSDictionary
            print(dictResponse)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "REMOVE PRODUCT!")
        })
    }
    
    func addProductToCurrentCart() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token, "product_id": "0", "store_id" : "0"]
        
        self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "add_product_to_cart", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
            self.stopLoadingIndicatorView()
            let dictResponse : NSDictionary = responseObject as! NSDictionary
            print(dictResponse)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "ADD CART!")
        })
    }
    
    
    func removeProductFromCurrentCart() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token, "product_id": "0", "store_id" : "0", "all" : "0"]
        
        self.sharedApi.baseRequestWithHTTPMethod("POST", URLString: "remove_product_from_wishlist", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
            self.stopLoadingIndicatorView()
            let dictResponse : NSDictionary = responseObject as! NSDictionary
            print(dictResponse)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "REMOVE CART!")
        })
    }
    
    func setUserLoggedOutFromApplication() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token]
        
        self.sharedApi.baseRequestWithHTTPMethod("DELETE", URLString: "logout", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
                self.stopLoadingIndicatorView()
                self.setUserLoginSession_AccessToken("")
                self.sharedApi.deleteAllTableContent()
                self.navigationController?.popToRootViewControllerAnimated(false)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "LOGOUT!")
        })
    }
    
    func showErrorMessageOnApiFailure(responseData : NSData, title : String) {
        do {
            let dictUser : AnyObject = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves)
            self.showErrorPopupWith_title_message(title, strMessage:dictUser["error"] as! String)
        }catch {
            self.showErrorPopupWith_title_message(title, strMessage:"Server Api error.")
        }
    }
    
    // MARK: - Common page loading View Methods.
    func startLoadingIndicatorView(){
        dispatch_async(dispatch_get_main_queue(),{
            QistLoadingOverlay.shared.showOverlay(self.view, lblText: "Loading...")
        })
    }
    
    func stopLoadingIndicatorView(){
        dispatch_async(dispatch_get_main_queue(),{
            QistLoadingOverlay.shared.hideOverlayView()
        })
    }
    
    
    // MARK: - Common Alert View Methods.
    func showErrorPopupWith_title_message(strTitle:String, strMessage:String){
        dispatch_async(dispatch_get_main_queue()) {
            self.alertQist = UIAlertController.alertWithTitleAndMessage(strTitle,message:strMessage, handler:{(objAlertAction : UIAlertAction!) -> Void in
            })
            self.presentViewController(self.alertQist, animated: true, completion: nil)
        }
    }
    
    func showBackNavAlertWith_title_message(strTitle:String, strMessage:String){
        dispatch_async(dispatch_get_main_queue()) {
            self.alertQist = UIAlertController.alertWithTitleAndMessage(strTitle,message:strMessage, handler:{(objAlertAction : UIAlertAction!) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            })
            self.presentViewController(self.alertQist, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - leftPanelDelegate Delegate Method.
    func getSelectedSectionWithRow(intSection:Int,intRow:Int,fromController:UIViewController){
        
        if intSection == 0 {
            switch intRow {
                
            case 0 :
                if !fromController.isKindOfClass(StoresController) {
                    let destination = self.storyboard?.instantiateViewControllerWithIdentifier("Stores") as! StoresController
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            case 1 :
                if !fromController.isKindOfClass(CartsController) {
                    let destination = self.storyboard?.instantiateViewControllerWithIdentifier("Carts") as! CartsController
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            case 2 :
                if !fromController.isKindOfClass(WishListsController) {
                    let destination = self.storyboard?.instantiateViewControllerWithIdentifier("WishLists") as! WishListsController
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            case 3 :
                if !fromController.isKindOfClass(SpecialsController) {
                    let destination = self.storyboard?.instantiateViewControllerWithIdentifier("Specials") as! SpecialsController
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            case 4 :
                if !fromController.isKindOfClass(LocateQistsController) {
                    let destination = self.storyboard?.instantiateViewControllerWithIdentifier("LocateQists") as! LocateQistsController
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            case 5 :
                if !fromController.isKindOfClass(ProfileController) {
                    let destination = self.storyboard?.instantiateViewControllerWithIdentifier("Profile") as! ProfileController
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            case 6 :
                if !fromController.isKindOfClass(SettingsController) {
                    let destination = self.storyboard?.instantiateViewControllerWithIdentifier("Settings") as! SettingsController
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            case 7 :
                if !fromController.isKindOfClass(HistoryController) {
                    let destination = self.storyboard?.instantiateViewControllerWithIdentifier("History") as! HistoryController
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            default :
                if !fromController.isKindOfClass(ScannerController) {
                    let destination = self.storyboard?.instantiateViewControllerWithIdentifier("Scanner") as! ScannerController
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            }
        }else {
            switch intRow {
                
            case 0 :
                if !fromController.isKindOfClass(AboutController) {
                    let destination = self.storyboard?.instantiateViewControllerWithIdentifier("About") as! AboutController
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            case 1 :
                if !fromController.isKindOfClass(SupportController) {
                    let destination = self.storyboard?.instantiateViewControllerWithIdentifier("Support") as! SupportController
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            case 2 : self.setUserLoggedOutFromApplication()
                
            default :
                if !fromController.isKindOfClass(ScannerController) {
                    let destination = self.storyboard?.instantiateViewControllerWithIdentifier("Scanner") as! ScannerController
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            }
        }
    }
    
    
    
    // MARK: - locationAuthorizationDelegate Delegate Method.
    func getLocationAuthorizationMessage(message:String){
        
        let alertController = UIAlertController(
            title: message,
            message: "In order to be notified about stores near you, please open this app's settings and set location access to 'Always'.",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(openAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: - These functions use for initialization and set layout.
    func initializeComponents(){
        initializeApplicationApiClient()
        // This function use for common initialization of components.
    }
    
    func configureComponentsLayout(){
        // This function use for set layout of components.
    }
    
    func assignDataToComponents(){
        // This function use for assign data to components.
    }
    
    func isAssignDataToComponents()->Bool{
        // This function use for triger, assignDataToComponents on viewDidAppear based on return value.
        return true
    }
    
    func initializeApplicationApiClient(){
        // This function use for Api initialization and retrun object.
        // initialization your App api class
        sharedApi = ApiClient.sharedApiClient()
        QistLocationManager.sharedManager.delegate = self
        leftView = LeftPanelView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height))
        leftView.delegate = self
        
        let arrFetchedData : NSArray = User.MR_findAll()
        objUser = arrFetchedData.count > 0 ? arrFetchedData.objectAtIndex(0) as! User : nil
        
    }
}
