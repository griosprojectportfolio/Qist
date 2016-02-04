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

    var isSearch : Bool = false

    var topSearchView : LocateQistSearchView!
    var arrStores : NSMutableArray = NSMutableArray()
    var arrSearchData : NSArray = NSArray()

    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "LOCATE QIST"
        getAllStoresInfoOnAddressFromServer()
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
            isSearch = true
            self.getSearchData(strAddress)
        }else {
            isSearch = false
            tblLocateQist.reloadData()
        }
    }

    // MARK: - Setup top view Contents and Actions Methods
    func setupTopViewDataContent(){

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
        if isSearch {
            return self.arrSearchData.count

        }else{
            return self.arrStores.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : LocateQistCell = tableView.dequeueReusableCellWithIdentifier("LocateCell",forIndexPath:indexPath) as! LocateQistCell
        cell.locateCellDelegate = self
        cell.tag = indexPath.row
        if isSearch {
            cell.configureLocateQistTableViewCell()
            cell.setupLocateQistCellContent(self.arrSearchData[indexPath.row] as! NSDictionary)
        }else{
            cell.configureLocateQistTableViewCell()
            cell.setupLocateQistCellContent(self.arrStores[indexPath.row] as! NSDictionary)

        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if isSearch {
            let vcObj = self.storyboard?.instantiateViewControllerWithIdentifier("StoreDetails") as! StoreDetailsController
            vcObj.dictDate = self.arrSearchData[indexPath.row] as! NSDictionary
            self.navigationController?.pushViewController(vcObj, animated: true)
        }else{
            let vcObj = self.storyboard?.instantiateViewControllerWithIdentifier("StoreDetails") as! StoreDetailsController
            vcObj.dictDate = self.arrStores[indexPath.row] as! NSDictionary
            self.navigationController?.pushViewController(vcObj, animated: true)

        }
    }

    // MARK: - locateQistCellDelegate method
    func favouriteButtonTapped(intTag:Int) {
        if isSearch {
            let selectedStore : NSDictionary = self.arrSearchData[intTag] as! NSDictionary
            let dictParams : NSDictionary = ["access_token": self.auth_token, "store_id": selectedStore["id"] as! String]
            self.setStoreAsFavourites(dictParams)
        }else {
            let selectedStore : NSDictionary = self.arrStores[intTag] as! NSDictionary
            let dictParams : NSDictionary = ["access_token": self.auth_token, "store_id": selectedStore["id"] as! String]
            self.setStoreAsFavourites(dictParams)
        }
    }



    func getSearchData(strSearch:NSString) {
        let predicate = NSPredicate(format: "trading_name contains[cd] %@", strSearch)
        let newList = arrStores .filteredArrayUsingPredicate(predicate) as NSArray
        arrSearchData =  newList
        if newList.count == 0 {
            let predicate = NSPredicate(format: "address contains[cd] %@", strSearch)
            arrSearchData = arrStores .filteredArrayUsingPredicate(predicate) as NSArray
        }
        if arrSearchData.count == 0 {
             self.showErrorPopupWith_title_message("LOCATE!", strMessage:"Please enter valid address.")
        }
        tblLocateQist.reloadData()
        print(arrSearchData)
    }


    // MARK: - API CALLS - Get all stores for Address
    func getAllStoresInfoOnAddressFromServer() {
        self.startLoadingIndicatorView()
        //let dictParams : NSDictionary = ["access_token": self.auth_token, "latitude": self.latitude,"longitude": self.longitude]
        let dictParams : NSDictionary = ["access_token": self.auth_token,"address": self.address]
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
        self.tblLocateQist?.frame = CGRectMake(self.tblLocateQist!.frame.origin.x, self.view.frame.origin.y + 44 ,self.tblLocateQist!.frame.size.width , self.view.frame.size.height - 44 )
    }

    override func assignDataToComponents(){
        // This function use for assign data to components.
    }
    
}