//
//  CartsController.swift
//  Qist
//
//  Created by GrepRuby3 on 23/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import MagicalRecord

class CartsController : BaseController, segmentedTapActionDelegate, cartsCellDelegate {
    
    @IBOutlet var tblCartsView : UITableView!
    var objCheckOutView : CheckOutView!
    
    var arrCarts : NSMutableArray = NSMutableArray()
    var arrWishlists : NSMutableArray = NSMutableArray()
    var isWishlists : Bool = false
    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "CARTS"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup befour appear the view.
        self.leftSegmentTappedAction()
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
        let segView : SegmentedView = SegmentedView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 64, self.view.frame.size.width, 35), leftBtnTitle: "CURRENT CART", rightBtnTitle: "WISHLIST")
        segView.delegate = self
        segView.addTopSegmentedButtonOnView(self)
    }
    
    func leftSegmentTappedAction() {
        self.isWishlists = false
        self.resetAllCollectionAndReloadViews()
        self.getAllCurrentCartInfoFromServer()
//        self.tblCartsView?.frame = CGRectMake(self.tblCartsView!.frame.origin.x, self.tblCartsView!.frame.origin.y ,self.tblCartsView!.frame.size.width , self.view.frame.size.height)
        self.setupCheckOutViewDataContent()
    }
    
    func rightSegmentTappedAction() {
        self.isWishlists = true
        self.resetAllCollectionAndReloadViews()
        self.getAllWishlistsInfoFromServer()
//        self.tblCartsView?.frame = CGRectMake(self.tblCartsView!.frame.origin.x, self.tblCartsView!.frame.origin.y ,self.tblCartsView!.frame.size.width , self.view.frame.size.height - 190 )
        self.removeCheckOutViewDataContent()
    }
    
    
    
    // MARK: - Setup top view Contents and Actions Methods
    func setupCartsTopViewDataContent(){
        
    }
    
    @IBAction func extendCartButtonTapped(sender: UIButton) {
        
    }
    
    
    
    // MARK: - TableView Delegate and Data Source Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isWishlists ? self.arrWishlists.count : self.arrCarts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CartsCell = tableView.dequeueReusableCellWithIdentifier("CartCell",forIndexPath:indexPath) as! CartsCell
        cell.tag = indexPath.row
        cell.cartsDelegate = self
        cell.configureCartsTableViewCell()
        cell.setupCartsCellContent(self.isWishlists ? self.arrWishlists[indexPath.row] as! NSDictionary : self.arrCarts[indexPath.row] as! NSDictionary)
        if self.isWishlists {
            cell.btnAddToCart.setImage(UIImage(named: "button_add_cart"), forState: UIControlState.Normal)
        }else {
            cell.btnAddToCart.setImage(UIImage(named: "button_remove_cart"), forState: UIControlState.Normal)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - cartsCellDelegate methods
    func removeProductFromWishListsTapped(intTag : Int) {
        self.removeProductFromWishLists(self.isWishlists ? self.arrWishlists[intTag] as! NSDictionary : self.arrCarts[intTag] as! NSDictionary)
        if self.isWishlists {
            self.arrWishlists.removeObjectAtIndex(intTag)
            self.tblCartsView.reloadData()

//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), {
//                self.arrWishlists.removeObjectAtIndex(intTag)
//                self.tblCartsView.reloadData()
//            })
            
        }else{
//            self.arrCarts.removeObjectAtIndex(intTag)
//            self.tblCartsView.reloadData()
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), {
//                self.arrCarts.removeObjectAtIndex(intTag)
//                self.tblCartsView.reloadData()
//            })
        }
    }
    
    func addOrRemoveProductFromCartsTapped(intTag : Int) {
        if self.isWishlists {
            self.addProductToCurrentCart(self.isWishlists ? self.arrWishlists[intTag] as! NSDictionary : self.arrCarts[intTag] as! NSDictionary)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), {
                self.getAllCurrentCartInfoFromServer()
            })
        }else{
            self.removeProductFromCurrentCart(self.isWishlists ? self.arrWishlists[intTag] as! NSDictionary : self.arrCarts[intTag] as! NSDictionary)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                dispatch_async(dispatch_get_main_queue(), {
                    self.arrCarts.removeObjectAtIndex(intTag)
                    print(self.arrCarts)
                    self.tblCartsView.reloadData()
                })
            })
        }
    }
    
    // MARK: - API CALLS - All Carts, Wish lists, Carts etc
    func getAllCurrentCartInfoFromServer() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token , "latitude" : self.latitude, "longitude" : self.longitude]
        print(dictParams)
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "current_cart", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
            self.stopLoadingIndicatorView()
            let dictResponse : NSDictionary = responseObject as! NSDictionary
            print(dictResponse)
            self.arrCarts = dictResponse["products"]?.mutableCopy() as! NSMutableArray
            self.tblCartsView.reloadData()
            
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                if task!.responseData != nil {
                    self.showErrorMessageOnApiFailure(task!.responseData!, title: "CARTS!")
                }else{
                    self.showErrorPopupWith_title_message("", strMessage:"Server request timed out.")
                }
        })
    }
    
    func getAllWishlistsInfoFromServer() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token , "latitude" : self.latitude, "longitude" : self.longitude]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "wishlist", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
            self.stopLoadingIndicatorView()
            let dictResponse : NSDictionary = responseObject as! NSDictionary
            self.arrWishlists = dictResponse["wishlist"]?.mutableCopy() as! NSMutableArray
            self.tblCartsView.reloadData()
            print(dictResponse)
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
    
    
    // MARK: - Setup Bottom CheckOut View Methods
    func setupCheckOutViewDataContent(){
        if self.arrCarts.count > 0 {
            self.objCheckOutView = CheckOutView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.size.height - 120, self.view.frame.size.width, 120),totalAmount: "$500", savedAmount: "$200")
            self.view.addSubview(self.objCheckOutView)
        }
    }
    
    func removeCheckOutViewDataContent() {
        if self.arrCarts.count > 0 {
            self.objCheckOutView.removeFromSuperview()
        }
    }
    
    
    // MARK: -  Carts page Common Methods
    func resetAllCollectionAndReloadViews() {
        self.arrCarts.removeAllObjects()
        self.arrWishlists.removeAllObjects()
        self.tblCartsView.reloadData()
    }
    
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        // This function use for set layout of components.
        self.setupTopSegmentedControlOnView()
        self.setupCartsTopViewDataContent()
        self.tblCartsView?.frame = CGRectMake(self.tblCartsView!.frame.origin.x, self.view.frame.origin.y+44 ,self.tblCartsView!.frame.size.width , self.view.frame.size.height-44)
    }
    
    override func assignDataToComponents(){
        // This function use for assign data to components.
    }
    
}