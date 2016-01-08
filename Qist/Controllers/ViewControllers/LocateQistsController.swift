//
//  LocateQistsController.swift
//  Qist
//
//  Created by GrepRuby3 on 24/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import MagicalRecord

class LocateQistsController : BaseController, locateQistSearchDelegate, locateQistCellDelegate {
    
    @IBOutlet var tblLocateQist : UITableView!
    
    @IBOutlet var lbl_Toptitle : UILabel!
    @IBOutlet var lbl_TopSubTitle: UILabel!
    @IBOutlet var lbl_TopExpire: UILabel!
    @IBOutlet var top_ImageView: UIImageView!
    
    var topSearchView : LocateQistSearchView!
    var arrStores : NSMutableArray = NSMutableArray()
    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "LOCATE QIST"
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
    
    
    // MARK: - Top Search view and locateQistSearchDelegate Methods
    func setupTopSearchControlOnView(){
        self.topSearchView = LocateQistSearchView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 64 ,self.view.frame.size.width,35 ))
        self.topSearchView.locateQistDelegate = self
        self.topSearchView.addTopSearchQistLocationOnView(self)
    }
    
    func searchQistForAddressTapped(strAddress : String) {
        if !strAddress.isEmpty {
            self.getAllStoresInfoOnAddressFromServer(strAddress)
        }else {
            self.showErrorPopupWith_title_message("LOCATE!", strMessage:"Please enter valid address.")
        }
    }
    
    // MARK: - Setup top view Contents and Actions Methods
    func setupTopViewDataContent(){
        
        self.lbl_Toptitle.textColor = UIColor.appCellTitleColor()
        self.lbl_Toptitle.font = UIFont.boldFontOfSize(14.0)
        self.lbl_Toptitle.text = "Weekly Special:Apple's Gold iWatch"
        
        self.lbl_TopSubTitle.textColor = UIColor.appCellSubTitleColor()
        self.lbl_TopSubTitle.numberOfLines = 0
        self.lbl_TopSubTitle.font = UIFont.defaultFontOfSize(09.0)
        self.lbl_TopSubTitle.text = "simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley."
        
        self.lbl_TopExpire.textColor = UIColor.appCellSubTitleColor()
        self.lbl_TopExpire.font = UIFont.defaultFontOfSize(09.0)
        self.lbl_TopExpire.text = "Expires: 2 DAYS 12 HRS"
        
    }
    
    @IBAction func addToCartButtonTapped(sender: UIButton) {
        
    }
    
    @IBAction func addToWishListButtonTapped(sender: UIButton) {
        
    }
    
    
    
    // MARK: - TableView Delegate and Data Source Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrStores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : LocateQistCell = tableView.dequeueReusableCellWithIdentifier("LocateCell",forIndexPath:indexPath) as! LocateQistCell
        cell.locateCellDelegate = self
        cell.tag = indexPath.row
        cell.configureLocateQistTableViewCell()
        cell.setupLocateQistCellContent(self.arrStores[indexPath.row] as! NSDictionary)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - locateQistCellDelegate method
    func favouriteButtonTapped(intTag:Int) {
        let selectedStore : NSDictionary = self.arrStores[intTag] as! NSDictionary
        let dictParams : NSDictionary = ["access_token": self.auth_token, "store_id": selectedStore["id"] as! String]
        self.setStoreAsFavourites(dictParams)
    }
    
    
    // MARK: - API CALLS - Get all stores for Address
    func getAllStoresInfoOnAddressFromServer(searchAddress:String) {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token, "address": searchAddress, "radius" : self.radius]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString:"nearby_stores", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.arrStores = dictResponse["stores"]?.mutableCopy() as! NSMutableArray
                self.tblLocateQist.reloadData()
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "LOCATE!")
        })
    }
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        // This function use for set layout of components.
        self.setupTopSearchControlOnView()
        self.setupTopViewDataContent()
        self.tblLocateQist?.frame = CGRectMake(self.tblLocateQist!.frame.origin.x, self.tblLocateQist!.frame.origin.y ,self.tblLocateQist!.frame.size.width , self.view.frame.size.height - 200 )
    }
    
    override func assignDataToComponents(){
        // This function use for assign data to components.
    }
    
}