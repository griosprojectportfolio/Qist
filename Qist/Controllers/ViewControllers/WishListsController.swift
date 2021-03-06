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
    var arrByStores : NSMutableArray = NSMutableArray()
    var arrByStoresCellContent : NSMutableArray = NSMutableArray()
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
            return intSection
        }else{
            intSection = 1
            return intSection
        }
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
        let dictObj = arrByStores.objectAtIndex(section) as! NSDictionary
        lblTitle.text = dictObj.valueForKey("trading_name") as? String
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
        var rows : Int
        if isByStore {
            if arrByStoresCellContent.count != 0 {
                let arrObj = arrByStoresCellContent.objectAtIndex(section) as! NSArray
                rows = arrObj.count
            }else {
                rows = 0
            }
            return rows
        }else {
            rows = self.arrWishists.count
            return rows
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : WishListsCell = tableView.dequeueReusableCellWithIdentifier("WishListCell",forIndexPath:indexPath) as! WishListsCell
        cell.wishlistsDelegate = self
        cell.tag = indexPath.row
        cell.configureWishListsTableViewCell()
        if isByStore {
            if arrByStoresCellContent.count != 0 {
                let arrObj = self.arrByStoresCellContent.objectAtIndex(indexPath.section) as! NSArray
                let dict = arrObj.objectAtIndex(indexPath.row) as! NSDictionary
                cell.setupWishListsCellContent(dict,indexpath:indexPath)
                let strPer = "Save: " + (self.calculateSavingPercentage(dict["qist_price"] as! String, originalPrice: dict["original_price"] as! String) as String) + "%"
                cell.lblProductSave.text = strPer
            }
        }else {
            let dict = arrWishists.objectAtIndex(indexPath.row) as! NSDictionary
            cell.setupWishListsCellContent(arrWishists.objectAtIndex(indexPath.row) as! NSDictionary,indexpath: indexPath)
            let strPer = "Save: " + (self.calculateSavingPercentage(dict["qist_price"] as! String, originalPrice: dict["original_price"] as! String) as String) + "%"
            cell.lblProductSave.text = strPer
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if isByStore {
        }else{
            let vcObj = self.storyboard?.instantiateViewControllerWithIdentifier("ProductDetail") as! ProductDetailController
            vcObj.dictDate = arrWishists.objectAtIndex(indexPath.row) as! NSDictionary
            vcObj.isCallViewController = "Wishlist"
            self.navigationController?.pushViewController(vcObj, animated: true)
        }
    }
    
    
    // MARK: -  Section Header view tap method
    func sectionHeaderTapAction(sender:UITapGestureRecognizer){
        let tag : Int =  Int(sender.view!.tag)
        if self.arrByStores[tag].count > 0 {
            let dictObj = arrByStores.objectAtIndex(tag) as! NSDictionary
            //self.arrByStoresCellContent.addObject(dictObj.valueForKey("Product") as! NSMutableArray)
            self.arrByStoresCellContent.replaceObjectAtIndex(tag, withObject:dictObj.valueForKey("Product") as! NSMutableArray)
        }else {
            self.arrByStores.replaceObjectAtIndex(tag, withObject:arrByStores.objectAtIndex(tag))
            print(self.arrByStores)
        }
        self.tblWishLists.reloadSections(NSIndexSet(index: tag), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    
    // MARK: - wishlistsCellDelegate methods
    func removeProductFromWishListsTapped(Indexpath: NSIndexPath) {
        if isByStore {
            let arrObj = self.arrByStoresCellContent.objectAtIndex(Indexpath.section) as! NSArray
            let dict = arrObj.objectAtIndex(Indexpath.row) as! NSDictionary
            self.removeProductFromWishLists(dict, successBlock: { () -> () in
                let arr = self.arrByStoresCellContent.objectAtIndex(Indexpath.section).mutableCopy()
                arr.removeObjectAtIndex(Indexpath.row)
                self.arrByStoresCellContent.insertObject(arr, atIndex:Indexpath.section)
                self.tblWishLists.reloadData()
                let dictObj = self.arrByStores.objectAtIndex(Indexpath.section).mutableCopy() as! NSMutableDictionary
                print(self.arrByStores)
                let arrmain = dictObj.valueForKey("Product")?.mutableCopy() as! NSMutableArray
                arrmain.removeObjectAtIndex(Indexpath.row)
                dictObj.setValue(arrmain, forKey: "Product")
                print(dictObj)
                self.arrByStores.replaceObjectAtIndex(Indexpath.section, withObject: dictObj)
                print(self.arrByStores)

                }, failureBlock: { () -> () in

            })
            }else {
            let dict = arrWishists.objectAtIndex(Indexpath.row) as! NSDictionary
            self.removeProductFromWishLists(dict, successBlock: { () -> () in
                self.arrWishists.removeObjectAtIndex(Indexpath.row)
                self.tblWishLists.reloadData()
                }, failureBlock: { () -> () in

            })
        }
    }
    
    func addProductToCartsTapped(Indexpath: NSIndexPath) {
        if isByStore {
            let arrObj = self.arrByStoresCellContent.objectAtIndex(Indexpath.section) as! NSArray
            let dict = arrObj.objectAtIndex(Indexpath.row) as! NSDictionary
            self.addProductToCurrentCart(dict)
        }else {
            let dict = arrWishists.objectAtIndex(Indexpath.row) as! NSDictionary
            self.addProductToCurrentCart(dict)
        }
    }
    
    // MARK: - API CALLS - Get WISHLISTS, CARTS etc
    func getAllWishlistsInfoFromServer() {
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token , "latitude" : self.latitude, "longitude" : self.longitude, "radius": self.radius]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "wishlist", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
            self.stopLoadingIndicatorView()
            let dictResponse : NSDictionary = responseObject as! NSDictionary
            self.arrWishists.removeAllObjects()
            self.arrWishists = dictResponse["wishlist"]?.mutableCopy() as! NSMutableArray
            self.tblWishLists.reloadData()
            print(self.arrWishists.count)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                if task!.responseData != nil {
                    self.arrWishists.removeAllObjects()
                    self.tblWishLists.reloadData()
                    self.showErrorMessageOnApiFailure(task!.responseData!, title: "WISHLISTS!")
                }else{
                    self.showErrorPopupWith_title_message("", strMessage:"Server request timed out.")
                }
        })
    }
    
    func getAllWishlistsByStoreInfoFromServer() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token , "latitude" : self.latitude, "longitude" : self.longitude, "radius": self.radius]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "wishlist_by_store", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
            self.stopLoadingIndicatorView()
            let dictResponse : NSDictionary = responseObject as! NSDictionary
            self.arrByStores = dictResponse.valueForKey("wishlist")?.mutableCopy() as! NSMutableArray
            print(self.arrByStores)
            self.dataProcess()
            self.tblWishLists.reloadData()
            
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                if task!.responseData != nil {
                    self.showErrorMessageOnApiFailure(task!.responseData!, title: "WISHLISTS!")
                }else{
                    self.showErrorPopupWith_title_message("", strMessage:"Server request timed out.")
                }
        })
    }
    
    func dataProcess() {
        for var i = 0 ;i < arrByStores.count ; i++ {
            arrByStoresCellContent.addObject([])
        }
        print(arrByStoresCellContent)
    }
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        // This function use for set layout of components.
        self.setupTopSegmentedControlOnView()
        self.setupWishListsTopViewDataContent()
        self.tblWishLists?.frame = CGRectMake(self.tblWishLists!.frame.origin.x, self.view.frame.origin.y+44,self.tblWishLists!.frame.size.width , self.view.frame.size.height - 44 )
    }
    
    override func assignDataToComponents(){
        // This function use for assign data to components.
    }
    
}