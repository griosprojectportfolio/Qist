//
//  AboutController.swift
//  Qist
//
//  Created by GrepRuby3 on 06/10/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class AboutController : BaseController {
    
    @IBOutlet var webView: UIWebView!
    var strAboutUs: String = String()
    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "ABOUT"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getAboutUsPageContentFromServer()
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
    func getAboutUsPageContentFromServer(){
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "about", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                let objPage : NSDictionary = dictResponse["page"] as! NSDictionary
                self.strAboutUs = objPage["content"] as! String
                self.webView.loadHTMLString(self.strAboutUs, baseURL: nil)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "ABOUT!")
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