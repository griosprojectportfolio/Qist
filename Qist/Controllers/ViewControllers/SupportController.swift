//
//  SupportController.swift
//  Qist
//
//  Created by GrepRuby3 on 06/10/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class SupportController : BaseController {
    
    @IBOutlet var webView: UIWebView!
    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "SUPPORT"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getSupportPageContentFromServer()
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
    func getSupportPageContentFromServer(){
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "support", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                let objPage : NSDictionary = dictResponse["page"] as! NSDictionary
                self.webView.loadHTMLString(objPage["content"] as! String, baseURL: nil)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "SUPPORT!")
        })
    }
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        // This function use for set layout of components.
    }
    
    override func assignDataToComponents(){
        // This function use for assign data to components.
    }
    
    
}