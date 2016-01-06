//
//  HistoryController.swift
//  Qist
//
//  Created by GrepRuby3 on 24/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class HistoryController : BaseController , segmentedTapActionDelegate {
    
    @IBOutlet var lblCurrentStore: UILabel!
    @IBOutlet var lblCurrentDate: UILabel!
    
    @IBOutlet var tblHistory : UITableView!
    
    var arrHistory : NSMutableArray = [[],[],[]]
    var isPurchase : Bool = false
    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "HISTORY"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup befour appear the view.
        self.getAllScanHistoryFromServer()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after appear the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - segmentedTapActionDelegate and their Delegate Methods
    func setupTopSegmentedControlOnView(){
        let segView : SegmentedView = SegmentedView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 64, self.view.frame.size.width, 35), leftBtnTitle: "SCANS", rightBtnTitle: "PURCHASES")
        segView.delegate = self
        segView.addTopSegmentedButtonOnView(self)
    }
    
    func leftSegmentTappedAction() {
        self.isPurchase = false
        self.getAllScanHistoryFromServer()
        self.tblHistory.reloadData()
    }
    
    func rightSegmentTappedAction() {
        self.isPurchase = true
        self.getAllPurchaseHistoryFromServer()
        self.tblHistory.reloadData()
    }
    
    
    
    // MARK: - Setup top view Contents and Actions Methods
    func setupHistoryTopViewDataContent(){
        
    }
    
    @IBAction func extendCartButtonTapped(sender: UIButton) {
        
    }
    
    
    
    // MARK: - TableView Delegate and Data Source Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.arrHistory.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView : UIView = UIView(frame: CGRectMake(self.tblHistory.frame.origin.x, self.tblHistory.frame.origin.y, self.tblHistory.frame.size.width, 30))
        headerView.backgroundColor = UIColor.clearColor()
        headerView.userInteractionEnabled = true
        headerView.tag = section
        let headerTap = UITapGestureRecognizer(target: self, action: Selector("sectionHeaderTapAction:"))
        headerView.addGestureRecognizer(headerTap)
        
        let lblTitle : UILabel = UILabel(frame: CGRectMake(headerView.frame.origin.x + 15, 10, headerView.frame.size.width - 30, 20))
        lblTitle.text = "H&J Smith,Southland"
        lblTitle.font = UIFont.boldFontOfSize(13)
        lblTitle.textColor = UIColor.appBackgroundColor()
        headerView.addSubview(lblTitle)
        
        let sepImgView : UIImageView = UIImageView(frame: CGRectMake(headerView.frame.origin.x + 15, headerView.frame.size.height - 1, headerView.frame.size.width - 30, 1))
        sepImgView.image = UIImage(named: "sidebar_divider")
        headerView.addSubview(sepImgView)
        
        let iconArrow : UIImageView = UIImageView()
        if self.arrHistory[section].count > 0 {
            iconArrow.frame = CGRectMake(headerView.frame.size.width - 30, 15, 15, 8)
            iconArrow.image = UIImage(named: "button_down")
        }else {
            iconArrow.frame = CGRectMake(headerView.frame.size.width - 30, 10, 8, 15)
            iconArrow.image = UIImage(named: "button_forward")
        }
        headerView.addSubview(iconArrow)

        return headerView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrHistory[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : HistoryCell = tableView.dequeueReusableCellWithIdentifier("HisCell",forIndexPath:indexPath) as! HistoryCell
        if self.isPurchase {
            cell.btnAddToCart.hidden = true
            cell.btnAddToishList.hidden = true
            cell.lblProductExp.hidden = true
            cell.clockImgView.hidden = true
        }else {
            cell.btnAddToCart.hidden = false
            cell.btnAddToishList.hidden = false
            cell.lblProductExp.hidden = false
            cell.clockImgView.hidden = false
        }
        cell.configureHistoryTableViewCell()
        cell.setupHistoryCellContent()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    // MARK: -  Section Header view tap method
    func sectionHeaderTapAction(sender:UITapGestureRecognizer){
        let tag : Int =  Int(sender.view!.tag)
        if self.arrHistory[tag].count > 0 {
            self.arrHistory.replaceObjectAtIndex(tag, withObject:[])
        }else {
            self.arrHistory.replaceObjectAtIndex(tag, withObject:["","",""])
        }
        self.tblHistory.reloadSections(NSIndexSet(index: tag), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    
    
    // MARK: - API CALLS - All Stores, Favourites Stores
    func getAllScanHistoryFromServer() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token, "customer_id": self.objUser.id!]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "scan_history", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                print(dictResponse)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                do {
                    let dictUser : AnyObject = try NSJSONSerialization.JSONObjectWithData(task!.responseData!, options: NSJSONReadingOptions.MutableLeaves)
                    self.showErrorPopupWith_title_message("HISTORY!", strMessage:dictUser["error"] as! String)
                }catch {
                    self.showErrorPopupWith_title_message("HISTORY!", strMessage:"Server Api error.")
                }
        })
    }
    
    func getAllPurchaseHistoryFromServer() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token, "customer_id": self.objUser.id!]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "purchase_history", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                print(dictResponse)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                do {
                    let dictUser : AnyObject = try NSJSONSerialization.JSONObjectWithData(task!.responseData!, options: NSJSONReadingOptions.MutableLeaves)
                    self.showErrorPopupWith_title_message("HISTORY!", strMessage:dictUser["error"] as! String)
                }catch {
                    self.showErrorPopupWith_title_message("HISTORY!", strMessage:"Server Api error.")
                }
        })
    }
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        // This function use for set layout of components.
        self.setupTopSegmentedControlOnView()
        self.setupHistoryTopViewDataContent()
        self.tblHistory?.frame = CGRectMake(self.tblHistory!.frame.origin.x, self.tblHistory!.frame.origin.y,self.tblHistory!.frame.size.width , self.view.frame.size.height - 190 )
        if isiPhone5 || isiPhone4s {
            self.lblCurrentStore.font = UIFont.defaultFontOfSize(12.0)
            self.lblCurrentDate.font = UIFont.defaultFontOfSize(12.0)
        }
    }
    
    override func assignDataToComponents(){
        // This function use for assign data to components.
    }
    
}