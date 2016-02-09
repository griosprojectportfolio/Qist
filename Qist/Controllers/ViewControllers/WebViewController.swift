//
//  WebViewController.swift
//  Qist
//
//  Created by GrepRuby on 08/02/16.
//  Copyright © 2016 GrepRuby3. All rights reserved.
//

import UIKit

class WebViewController: BaseController,UIWebViewDelegate {

    @IBOutlet var webView : UIWebView!
    var strwebUrl : NSString!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL (string: strwebUrl as String)
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: -  Overrided Methods of BaseController
    override func leftNavBackButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - WebView delegates methods

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print(error)
        self.stopLoadingIndicatorView()
        self.showErrorPopupWith_title_message("Web!", strMessage:"Not Responding.")
    }

    func webViewDidStartLoad(webView: UIWebView) {
        self.startLoadingIndicatorView()
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        self.stopLoadingIndicatorView()
    }
    
}
