//
//  StoreDetailsController.swift
//  Qist
//
//  Created by GrepRuby on 03/02/16.
//  Copyright © 2016 GrepRuby3. All rights reserved.
//

import UIKit
import MessageUI

class StoreDetailsController: BaseController,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate {

    @IBOutlet var imgView : UIImageView!
    @IBOutlet var tblSotreDetail : UITableView!
    @IBOutlet var txtView : UITextView!
    @IBOutlet var btnFB : UIButton!
    @IBOutlet var btnGPlus : UIButton!
    @IBOutlet var btnTwitter : UIButton!


    var dictDate : NSDictionary!

    var arrCellTitle  : NSArray = NSArray(objects: "Store Name","Address","Website","Phone","Email")
    var arrCellContent : NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        print(dictDate)
        self.title = dictDate["trading_name"] as? String
        txtView.editable = false
        dataNilCheck()
    }

    func dataNilCheck() {
        if let storeName = dictDate["trading_name"] as? String {
            arrCellContent.addObject(storeName)
        }else{
            arrCellContent.addObject("")
        }

        if let address = dictDate["address"] as? String {
            arrCellContent.addObject(address)
        }else{
            arrCellContent.addObject("")
        }

        if let website = dictDate["work_url"] as? String {
            arrCellContent.addObject(website)
        }else{
            arrCellContent.addObject("")
        }

        if let phone_1 = dictDate["work_phone_1"] as? String {
            arrCellContent.addObject(phone_1)
        }else{
            arrCellContent.addObject("")
        }

        if let email = dictDate["email"] as? String {
            arrCellContent.addObject(email)
        }else{
            arrCellContent.addObject("")
        }

        let arrKeys = dictDate.allKeys as NSArray
        if arrKeys.containsObject("logo_url") {
            let imgUrl : NSURL = NSURL(string: (dictDate.valueForKey("logo_url") as! String))!
            imgView.sd_setImageWithURL(imgUrl, placeholderImage: UIImage(named: "No_image"))
        }else {
            imgView.image = UIImage(named: "No_image")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup befour appear the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after appear the view.
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCellTitle.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellObj = tableView.dequeueReusableCellWithIdentifier("storedetail")! as UITableViewCell
        cellObj.textLabel?.text = arrCellTitle.objectAtIndex(indexPath.row) as? String
        cellObj.textLabel?.textColor = UIColor.appCellTitleColor()
        cellObj.textLabel?.font = UIFont.boldFontOfSize(12)
        cellObj.textLabel?.numberOfLines = 0

        cellObj.detailTextLabel?.text = arrCellContent.objectAtIndex(indexPath.row) as? String
        cellObj.detailTextLabel?.textColor = UIColor.appCellSubTitleColor()
        cellObj.detailTextLabel?.font = UIFont.normalFontOfSize(12)
        cellObj.detailTextLabel?.numberOfLines = 0
        if indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 {
            cellObj.detailTextLabel?.textColor = UIColor.blueColor()
        }else {
            cellObj.detailTextLabel?.textColor = UIColor.appCellSubTitleColor()
        }

        return cellObj
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        switch indexPath.row {
        case 1:
            if arrCellContent.objectAtIndex(indexPath.row) as! NSString != "" {
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MapView") as! MapViewController
                vc.strLat = dictDate.valueForKey("latitude") as! String
                vc.strLog = dictDate.valueForKey("longitude") as! String
                vc.strAddress = dictDate.valueForKey("address") as! String
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                //self.showErrorPopupWith_title_message("", strMessage:"Server request timed out.")
            }
            break
        case 2:
            if arrCellContent.objectAtIndex(indexPath.row) as! NSString != "" {
                callAWebView(arrCellContent.objectAtIndex(indexPath.row) as! String)
            }else {
                //self.showErrorPopupWith_title_message("", strMessage:"Server request timed out.")
            }
            break
        case 3:
            if arrCellContent.objectAtIndex(indexPath.row) as! NSString != "" {
                makeACall(arrCellContent.objectAtIndex(indexPath.row) as! String)
            }else {
                //self.showErrorPopupWith_title_message("", strMessage:"Server request timed out.")
            }
            break
        case 4:
            if arrCellContent.objectAtIndex(indexPath.row) as! NSString != "" {
                sendEmail(arrCellContent.objectAtIndex(indexPath.row) as! String)
            }else {
                //self.showErrorPopupWith_title_message("", strMessage:"Server request timed out.")
            }
            break
        default :
            break
        }

    }

    func callAWebView(strUrl:String) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("WebView") as! WebViewController
        vc.strwebUrl = strUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func makeACall(number:String) {
        let phone = "tel://" + number ;
        let url:NSURL = NSURL(string:phone)!;
        UIApplication.sharedApplication().openURL(url);
    }

    func sendEmail(recipients:String) {
        print(recipients)
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipients])
            mail.setMessageBody("", isHTML: true)

            presentViewController(mail, animated: true, completion: nil)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch (result) {
        case MFMailComposeResultSent:
            self.showErrorPopupWith_title_message("", strMessage:"You sent the email.")
            break
        case MFMailComposeResultSaved:
            self.showErrorPopupWith_title_message("", strMessage:"You saved a draft of this email.")
            break;
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultFailed:
            self.showErrorPopupWith_title_message("", strMessage:"Mail failed:  An error occurred when trying to compose this email.")
            break;
        default:
            break
        }

        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func btnFBTapped(sender:UIButton) {
        if dictDate.valueForKey("fb_link") as! String != "" {
            callAWebView(dictDate.valueForKey("fb_link") as! String)
        }else {

        }
    }

    @IBAction func btnGPlusTapped(sender:UIButton) {
        if dictDate.valueForKey("google_link") as! String != "" {
            callAWebView(dictDate.valueForKey("google_link") as! String)
        }else {

        }
    }

    @IBAction func btnTwitterTapped(sender:UIButton) {
        if dictDate.valueForKey("twitter_link") as! String != "" {
            callAWebView(dictDate.valueForKey("twitter_link") as! String)
        }else {

        }
    }

    // MARK: -  Overrided Methods of BaseController
    override func leftNavBackButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func configureComponentsLayout(){
        // This function use for set layout of components.
    }
    
    override func assignDataToComponents(){
        // This function use for assign data to components.
    }
    
    
}
