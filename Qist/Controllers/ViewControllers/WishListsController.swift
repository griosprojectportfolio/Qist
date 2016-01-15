//
//  WishListsController.swift
//  Qist
//
//  Created by GrepRuby3 on 24/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import MagicalRecord

class WishListsController : BaseController ,segmentedTapActionDelegate, wishlistsCellDelegate {
    
    @IBOutlet var lblCurrentStore: UILabel!
    @IBOutlet var lblCurrentDate: UILabel!
    
    @IBOutlet var tblWishLists : UITableView!
    
    var arrWishists : NSMutableArray = NSMutableArray()
    var arrByStores : NSMutableArray = [[],[],[]]
    var isByStore : Bool = false
    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "WISHLISTS"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllWishlistsInfoFromServer()
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
    
    
    // MARK: - segmentedTapActionDelegate and their Delegate Methods
    func setupTopSegmentedControlOnView(){
        let segView : SegmentedView = SegmentedView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 64, self.view.frame.size.width, 35), leftBtnTitle: "ALL ITEMS", rightBtnTitle: "BY STORE")
        segView.delegate = self
        segView.addTopSegmentedButtonOnView(self)
    }
    
    func leftSegmentTappedAction() {
        isByStore = false
        self.getAllWishlistsInfoFromServer()
        self.tblWishLists.reloadData()
    }
    
    func rightSegmentTappedAction() {
        isByStore = true
        self.getAllWishlistsByStoreInfoFromServer()
        self.tblWishLists.reloadData()
    }
    
    
    
    // MARK: - Setup top view Contents and Actions Methods
    func setupWishListsTopViewDataContent(){
        
    }
    
    @IBAction func extendCartButtonTapped(sender: UIButton) {
        
    }
    
    
    // MARK: - TableView Delegate and Data Source Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var intSection : Int = Int(1)
        if isByStore {
            intSection = self.arrByStores.count
        }
        return intSection
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height : CGFloat = 0.0
        if isByStore {
            height = 35.0
        }
        return height
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView : UIView = UIView(frame: CGRectMake(self.tblWishLists.frame.origin.x, self.tblWishLists.frame.origin.y, self.tblWishLists.frame.size.width, 30))
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
        if self.arrByStores[section].count > 0 {
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
        var rows : Int = Int(6)
        if isByStore {
            rows = self.arrByStores[section].count
        }
        return rows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : WishListsCell = tableView.dequeueReusableCellWithIdentifier("WishListCell",forIndexPath:indexPath) as! WishListsCell
        cell.wishlistsDelegate = self
        cell.tag = indexPath.row
        cell.configureWishListsTableViewCell()
        cell.setupWishListsCellContent()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: -  Section Header view tap method
    func sectionHeaderTapAction(sender:UITapGestureRecognizer){
        let tag : Int =  Int(sender.view!.tag)
        if self.arrByStores[tag].count > 0 {
            self.arrByStores.replaceObjectAtIndex(tag, withObject:[])
        }else {
            self.arrByStores.replaceObjectAtIndex(tag, withObject:["","",""])
        }
        self.tblWishLists.reloadSections(NSIndexSet(index: tag), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
   
    
    // MARK: - wishlistsCellDelegate methods
    func removeProductFromWishListsTapped(intTag : Int) {
    
    }
    
    func addProductToCartsTapped(intTag : Int) {
    
    }

    
    
    // MARK: - API CALLS - Get WISHLISTS, CARTS etc
    func getAllWishlistsInfoFromServer() {
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token , "latitude" : self.latitude, "longitude" : self.longitude, "radius": self.radius]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "wishlist", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.arrWishists = dictResponse["products"]?.mutableCopy() as! NSMutableArray
                self.tblWishLists.reloadData()
                print(dictResponse)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "WISHLISTS!")
        })
    }
    
    func getAllWishlistsByStoreInfoFromServer() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token , "latitude" : self.latitude, "longitude" : self.longitude, "radius": self.radius]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "wishlist_by_store", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.tblWishLists.reloadData()
                print(dictResponse)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "WISHLISTS!")
        })
    }
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        // This function use for set layout of components.
        self.setupTopSegmentedControlOnView()
        self.setupWishListsTopViewDataContent()
        self.tblWishLists?.frame = CGRectMake(self.tblWishLists!.frame.origin.x, self.tblWishLists!.frame.origin.y,self.tblWishLists!.frame.size.width , self.view.frame.size.height - 190 )
        if isiPhone5 || isiPhone4s {
            self.lblCurrentStore.font = UIFont.defaultFontOfSize(12.0)
            self.lblCurrentDate.font = UIFont.defaultFontOfSize(12.0)
        }
    }
    
    override func assignDataToComponents(){
        // This function use for assign data to components.
    }
    
}