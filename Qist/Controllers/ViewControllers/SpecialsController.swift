//
//  SpecialsController.swift
//  Qist
//
//  Created by GrepRuby3 on 24/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import MagicalRecord

class SpecialsController : BaseController , segmentedTapActionDelegate, specialsCellDelegate {
    
    @IBOutlet var tblSpecials : UITableView!

    var arrSpecials : NSMutableArray = NSMutableArray()
    var arrJustForYou : NSMutableArray = NSMutableArray()
    var isJustForYou : Bool = false

    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "SPECIALS"
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
        let segView : SegmentedView = SegmentedView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 64, self.view.frame.size.width, 35), leftBtnTitle: "ALL SPECIALS", rightBtnTitle: "JUST FOR YOU")
        segView.delegate = self
        segView.addTopSegmentedButtonOnView(self)
    }
    
    func leftSegmentTappedAction() {
        self.isJustForYou = false
        self.resetAllCollectionAndReloadViews()
        self.getAllSpecialProductFromServer()
    }
    
    func rightSegmentTappedAction() {
        self.isJustForYou = true
        self.resetAllCollectionAndReloadViews()
        self.getAllJustForYouProductFromServer()
    }
    
    
    
    // MARK: - Setup top view Contents and Actions Methods
    func setupTopViewDataContent(){

    }
    
    @IBAction func addToCartButtonTapped(intTag: Int) {
        
        let selectedStore : NSDictionary = self.isJustForYou ? self.arrJustForYou[intTag] as! NSDictionary : self.arrSpecials[intTag] as! NSDictionary
        let dictParams : NSDictionary = ["access_token": self.auth_token, "store_id": selectedStore["id"] as! String]
        
        if self.isJustForYou {
            self.setStoreAsUnFavourites(dictParams)
        }else {
            self.setStoreAsFavourites(dictParams)
        }
    }
    
    @IBAction func addToWishListButtonTapped(intTag: Int) {
        
    }
    

    // MARK: - TableView Delegate and Data Source Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isJustForYou ? self.arrJustForYou.count : self.arrSpecials.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : SpecialsCell = tableView.dequeueReusableCellWithIdentifier("SpecialCell",forIndexPath:indexPath) as! SpecialsCell
        cell.specialsDelegate = self
        cell.tag = indexPath.row
        let dict = self.isJustForYou ? self.arrJustForYou[indexPath.row] as! NSDictionary : self.arrSpecials[indexPath.row] as! NSDictionary
        cell.configureStoreTableViewCell()
        cell.setupSpecialsCellContent(dict)
        let strPer = "Save: " + (self.calculateSavingPercentage(dict["qist_price"] as! String, originalPrice: dict["original_price"] as! String) as String) + "%"
        cell.lblProductSave.text = strPer
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vcObj = self.storyboard?.instantiateViewControllerWithIdentifier("ProductDetail") as! ProductDetailController
        if self.isJustForYou {

        }else{
            vcObj.dictDate = self.isJustForYou ? self.arrJustForYou[indexPath.row] as! NSDictionary : self.arrSpecials[indexPath.row] as! NSDictionary
            vcObj.isCallViewController = "Specials"
        }
        self.navigationController?.pushViewController(vcObj, animated:true)
    }
    
    
    // MARK: - specialsCellDelegate methods
    func addProductToWishlistsTapped(intTag : Int) {
        print("Cell object == \(self.isJustForYou ? self.arrJustForYou[intTag] as! NSDictionary : self.arrSpecials[intTag] as! NSDictionary)")
        let dict = arrSpecials.objectAtIndex(intTag) as! NSDictionary
        self.addProductToWishLists(dict)
    }
    
    func addProductToCartsTapped(intTag : Int) {
        print("Cell object == \(self.isJustForYou ? self.arrJustForYou[intTag] as! NSDictionary : self.arrSpecials[intTag] as! NSDictionary)")
        let dict = arrSpecials.objectAtIndex(intTag) as! NSDictionary
        self.addProductToCurrentCart(dict)
    }

    
    
    // MARK: - API CALLS - All Specials and Just for you Stores
    func getAllSpecialProductFromServer() {
        
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "specials", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.arrSpecials = dictResponse["products"]?.mutableCopy() as! NSMutableArray
                self.tblSpecials.reloadData()
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                if task!.responseData != nil {
                     self.showErrorMessageOnApiFailure(task!.responseData!, title: "SPECIALS!")
                }else{
                    self.showErrorPopupWith_title_message("", strMessage:"Server request timed out.")
                }
                
        })
    }
    
    func getAllJustForYouProductFromServer() {
        self.startLoadingIndicatorView()
        let dictParams : NSDictionary = ["access_token": self.auth_token]
        
        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "just_for_you", parameters: dictParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
            
                self.stopLoadingIndicatorView()
                let dictResponse : NSDictionary = responseObject as! NSDictionary
                self.arrJustForYou = dictResponse["products"]?.mutableCopy() as! NSMutableArray
                self.tblSpecials.reloadData()
            },
            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
                self.stopLoadingIndicatorView()
                if task!.responseData != nil {
                    self.showErrorMessageOnApiFailure(task!.responseData!, title: "JUST FOR YOU!")
                }else{
                    self.showErrorPopupWith_title_message("", strMessage:"Server request timed out.")
                }
        })
    }
    
    
    // MARK: -  Specials page Common Methods
    func resetAllCollectionAndReloadViews() {
        self.arrSpecials.removeAllObjects()
        self.arrJustForYou.removeAllObjects()
        self.tblSpecials.reloadData()
    }
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        // This function use for set layout of components.
        self.setupTopSegmentedControlOnView()
        self.setupTopViewDataContent()
        self.tblSpecials?.frame = CGRectMake(self.tblSpecials!.frame.origin.x, self.view.frame.origin.y + 44 ,self.tblSpecials!.frame.size.width , self.view.frame.size.height - 44 )
    }
    
}