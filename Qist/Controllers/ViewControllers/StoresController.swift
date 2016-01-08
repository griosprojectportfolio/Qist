//
//  StoresController.swift
//  Qist
//
//  Created by GrepRuby3 on 23/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

class StoresController : BaseController , segmentedTapActionDelegate , storeCellDelegate {
    
    @IBOutlet var tblView : UITableView!
    
    @IBOutlet var lbl_Toptitle : UILabel!
    @IBOutlet var lbl_TopSubTitle: UILabel!
    @IBOutlet var lbl_TopExpire: UILabel!
    @IBOutlet var top_ImageView: UIImageView!
    
    var arrStores : NSMutableArray = NSMutableArray()
    var arrFavStores : NSMutableArray = NSMutableArray()
    var isMyFavourite : Bool = false
    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "STORES"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.leftSegmentTappedAction()
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
        let segView : SegmentedView = SegmentedView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 64, self.view.frame.size.width, 35), leftBtnTitle: "ALL STORES", rightBtnTitle: "MY FAVOURITES")
        segView.delegate = self
        segView.addTopSegmentedButtonOnView(self)
    }
    
    func leftSegmentTappedAction() {
        self.isMyFavourite = false
        self.resetAllCollectionAndReloadViews()
        self.getAllStoresInfoFromServer()
    }
    
    func rightSegmentTappedAction() {
        self.isMyFavourite = true
        self.resetAllCollectionAndReloadViews()
        self.getAllFavouriteStoresInfoFromServer()
    }
    
    
    
    // MARK: - Setup top view Contents and Actions Methods
    func setupStoresTopViewDataContent(){
        
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
        return self.isMyFavourite ? self.arrFavStores.count : self.arrStores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : StoresCell = tableView.dequeueReusableCellWithIdentifier("StoreCell",forIndexPath:indexPath) as! StoresCell
        cell.storeDelegate = self
        cell.tag = indexPath.row
        cell.configureStoreTableViewCell()
        cell.setupStoreCellContent(self.isMyFavourite ? self.arrFavStores[indexPath.row] as! NSDictionary : self.arrStores[indexPath.row] as! NSDictionary)
        
        if self.isMyFavourite {
            cell.btnHeart.setBackgroundImage(UIImage(named: "store_icon_remove_fav"), forState: UIControlState.Normal)
        }else {
            cell.btnHeart.setBackgroundImage(UIImage(named: "store_icon_add_fav"), forState: UIControlState.Normal)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - storeCellDelegate methods
    func favouriteAndUnfavouriteTapped(intTag : Int) {
        
        let selectedStore : NSDictionary = self.isMyFavourite ? self.arrFavStores[intTag] as! NSDictionary : self.arrStores[intTag] as! NSDictionary
        let dictParams : NSDictionary = ["access_token": self.auth_token, "store_id": selectedStore["id"] as! String]

        if self.isMyFavourite {
            self.setStoreAsUnFavourites(dictParams)
        }else {
            self.setStoreAsFavourites(dictParams)
        }
    }
    
    
    // MARK: - API CALLS - All Stores, Favourites Stores
    func getAllStoresInfoFromServer() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token , "latitude" : self.latitude, "longitude" : self.longitude, "radius": self.radius]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "stores", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.arrStores = dictResponse["stores"]?.mutableCopy() as! NSMutableArray
                self.tblView.reloadData()
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "ALL STORES!")
        })
    }
    
    func getAllFavouriteStoresInfoFromServer() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token , "latitude" : self.latitude, "longitude" : self.longitude, "radius": self.radius]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "favourite_store", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.arrFavStores = dictResponse["stores"]?.mutableCopy() as! NSMutableArray
                self.tblView.reloadData()
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "MY FAVOURITES!")
        })
    }
    
    
    // MARK: -  Store page Common Methods
    func resetAllCollectionAndReloadViews() {
        self.arrStores.removeAllObjects()
        self.arrFavStores.removeAllObjects()
        self.tblView.reloadData()
    }
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        // This function use for set layout of components.
        self.setupTopSegmentedControlOnView()
        self.setupStoresTopViewDataContent()
        self.tblView?.frame = CGRectMake(self.tblView!.frame.origin.x, self.tblView!.frame.origin.y - 64 ,self.tblView!.frame.size.width , self.view.frame.size.height - 135 )
    }
    
    override func assignDataToComponents(){
        // This function use for assign data to components.
    }
}