//
//  CartsController.swift
//  Qist
//
//  Created by GrepRuby3 on 23/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class CartsController : BaseController, segmentedTapActionDelegate, cartsCellDelegate {
    
    @IBOutlet var lblCurrentStore: UILabel!
    @IBOutlet var lblCurrentDate: UILabel!
    
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
        self.tblCartsView?.frame = CGRectMake(self.tblCartsView!.frame.origin.x, self.tblCartsView!.frame.origin.y ,self.tblCartsView!.frame.size.width , self.view.frame.size.height - 310 )
        self.setupCheckOutViewDataContent()
    }
    
    func rightSegmentTappedAction() {
        self.isWishlists = true
        self.resetAllCollectionAndReloadViews()
        self.getAllWishlistsInfoFromServer()
        self.tblCartsView?.frame = CGRectMake(self.tblCartsView!.frame.origin.x, self.tblCartsView!.frame.origin.y ,self.tblCartsView!.frame.size.width , self.view.frame.size.height - 190 )
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
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - cartsCellDelegate methods
    func removeProductFromWishListsTapped(intTag : Int) {
    
    }
    
    func addOrRemoveProductFromCartsTapped(intTag : Int) {
    
    }

    
    
    // MARK: - API CALLS - All Carts, Wish lists, Carts etc
    func getAllCurrentCartInfoFromServer() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token , "latitude" : self.latitude, "longitude" : self.longitude]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "current_cart", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                print(dictResponse)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "CARTS!")
        })
    }
    
    func getAllWishlistsInfoFromServer() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token , "latitude" : self.latitude, "longitude" : self.longitude]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "wishlist", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                print(dictResponse)
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                self.showErrorMessageOnApiFailure(task!.responseData!, title: "WISHLISTS!")
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
        self.tblCartsView?.frame = CGRectMake(self.tblCartsView!.frame.origin.x, self.tblCartsView!.frame.origin.y ,self.tblCartsView!.frame.size.width , self.view.frame.size.height - 310 )
        if isiPhone5 || isiPhone4s {
            self.lblCurrentStore.font = UIFont.defaultFontOfSize(12.0)
            self.lblCurrentDate.font = UIFont.defaultFontOfSize(12.0)
        }
    }
    
   override func assignDataToComponents(){
        // This function use for assign data to components.
    }
    
}