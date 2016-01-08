//
//  GooglePlus.swift
//  Qist
//
//  Created by GrepRuby3 on 17/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

let clientID = "437235601525-68q340io6ud4nq95i3u5pkon4v3v5f4j.apps.googleusercontent.com"
let clientSecret = "1HYqoSXCiKesPtdo54NztvoE"
let redirectURI = "http://localhost"
let scope = "https://www.googleapis.com/auth/userinfo.email"
let visibleactions = "http://schemas.google.com/AddActivity"
let authorizationURL = NSURL(string: "https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=" + clientID + "&redirect_uri=" + redirectURI + "&scope=" + scope + "&data-requestvisibleactions=" + visibleactions)!

import Foundation
import UIKit
import AFNetworking

protocol googlePlusDataDelegate{
    func currentGooglePlusUserData(aDictionary : NSDictionary)
    func failedToGetGooglePlusUserData(errorMessage : String)
}

class GooglePlus : BaseController , UIWebViewDelegate {
    
    var webView : UIWebView = UIWebView()
    var loadingIndicator: UIActivityIndicatorView!
    let btnBack: UIButton = UIButton(type: UIButtonType.Custom)
    var gPlusDelegate : googlePlusDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "LOGIN"
        // Do any additional setup after loading the view, typically from a nib.
        self.addRightAndLeftNavItemOnView()
        self.setUpActivityIndicator()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup befour appear the view.
        self.loadGooglePlusLoginView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after appear the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Add Navigation bar Images
    func addRightAndLeftNavItemOnView(){
        btnBack.frame = CGRectMake(0, 0, 32, 32)
        btnBack.setImage(UIImage(named:"down_arrow"), forState: UIControlState.Normal)
        btnBack.addTarget(self, action: "leftBackButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarButtonItemback: UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItemback, animated: false)
    }
    
    func leftBackButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Activity Indicaor Methods
    func setUpActivityIndicator(){
        loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100)) as UIActivityIndicatorView
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        loadingIndicator.color = UIColor.appBackgroundColor()
        self.webView.addSubview(loadingIndicator)
    }
    
    
    // MARK: - Google Plus Login Methods and their Delegates
    func loadGooglePlusLoginView(){
        webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        webView.delegate = self
        self.removeCacheFromInAppBrowser()
        let urlRequest : NSURLRequest = NSURLRequest(URL: authorizationURL)
        webView.loadRequest(urlRequest)
        self.view.addSubview(webView)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL?.absoluteString
        if let range = urlString!.rangeOfString( redirectURI + "/?code=") {
            let location = range.endIndex
            let code = urlString!.substringFromIndex(location)
            self.requestAccessToken(code)
            return false
        }
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadingIndicator.stopAnimating()
    }

    
    // MARK: - Remove In app Browser Cache
    func removeCacheFromInAppBrowser(){
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        if let cookies : [NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in cookies {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
            }
        }
    }
    
    
    // MARK: - Google Plus Fetch Access Token Method
    func requestAccessToken(code: String) {
        
        let params = ["client_id": clientID, "client_secret": clientSecret, "grant_type": "authorization_code", "redirect_uri": redirectURI, "code": code ]
        
        loadingIndicator.stopAnimating()
        activityIndicator = ActivityIndicatorView(frame: self.view.frame)
        activityIndicator.startActivityIndicator(self)
        
        self.sharedApi.serverCallWith_Post(params ,URLString: "https://accounts.google.com/o/oauth2/token", successBlock:{(operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
            
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.getGooglePlusUserBasicInformation(dictResponse["access_token"] as! String)
            
            }, failureBlock: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
                
                self.activityIndicator.stopActivityIndicator(self)
                self.gPlusDelegate?.failedToGetGooglePlusUserData("There is some authentication problem.")
        })
    }
    
    
    // MARK: - Google Plus Fetch User Info Method
    func getGooglePlusUserBasicInformation(access_token: String) {
        
        let profileUrl : String = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=\(access_token)"
        let params : NSDictionary = NSDictionary()
        
        self.sharedApi.serverCallWith_Get(params ,URLString: profileUrl , successBlock:{(operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
            
                self.activityIndicator.stopActivityIndicator(self)
                let dictResponse : NSDictionary = responseObject as! NSDictionary
            
                self.dismissViewControllerAnimated(true, completion: {
                    self.gPlusDelegate?.currentGooglePlusUserData(dictResponse)
                })
            
            }, failureBlock: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
                
                self.activityIndicator.stopActivityIndicator(self)
                self.gPlusDelegate?.failedToGetGooglePlusUserData("failed to get Google Plus user info, please try again.")
        })
    }
    
}