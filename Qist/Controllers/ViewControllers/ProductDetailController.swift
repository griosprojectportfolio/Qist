//
//  ProductDetailController.swift
//  Qist
//
//  Created by GrepRuby on 18/02/16.
//  Copyright © 2016 GrepRuby3. All rights reserved.
//

import UIKit

class ProductDetailController: BaseController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tblProductDetail : UITableView!
    @IBOutlet var txtView : UITextView!
    @IBOutlet var imgView : UIImageView!
    @IBOutlet var btnAddToCart :UIButton!
    @IBOutlet var btnAddToWishlist :UIButton!

    var dictDate : NSDictionary!
    var isCallViewController : String!

    var arrCellTitle  : NSMutableArray = NSMutableArray(objects: "Product Name","Qist Price","MRP","Save","Vaild From Date","Vaild To Date")
    var arrCellContent : NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(dictDate)
        self.title = dictDate.valueForKey("name") as? String
        txtView.text = dictDate.valueForKey("description") as? String
        txtView.editable = false
        dataNilCheck()
        isBottomButtonEnable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dataNilCheck() {
        if let productName = dictDate["name"] as? String {
            arrCellContent.addObject(productName)
        }else{
            arrCellContent.addObject("")
        }

        if let qistPrice = dictDate["qist_price"] as? String {
            arrCellContent.addObject(qistPrice)
        }else{
            arrCellContent.addObject("")
        }

        if let mrp = dictDate["original_price"] as? String {
            arrCellContent.addObject(mrp)
        }else{
            arrCellContent.addObject("")
        }

        if (dictDate["original_price"] != nil && dictDate["qist_price"] != nil) {
            let strPer = (self.calculateSavingPercentage(dictDate["qist_price"] as! String, originalPrice: dictDate["original_price"] as! String) as String) + "%"
            arrCellContent.addObject(strPer)
        }else{
            arrCellContent.addObject("")
        }

        if let valid_from_date = dictDate["valid_from_date"] as? String {
            arrCellContent.addObject(valid_from_date)
        }else{
            arrCellContent.addObject("")
        }

        if let valid_to_date = dictDate["valid_to_date"] as? String {
            arrCellContent.addObject(valid_to_date)
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

    func isBottomButtonEnable() {
        if self.isCallViewController == "Specials"{
            btnAddToWishlist.setImage(UIImage(imageLiteral: "button_add_wishlist"), forState: UIControlState.Normal)
            btnAddToCart.setImage(UIImage(imageLiteral: "button_add_cart"), forState: UIControlState.Normal)
        }else if self.isCallViewController == "Wishlist" {
            btnAddToWishlist.setImage(UIImage(imageLiteral: "button_remove_wishlist"), forState: UIControlState.Normal)
            btnAddToCart.setImage(UIImage(imageLiteral: "button_add_cart"), forState: UIControlState.Normal)
        }
    }


    @IBAction func btnAddToCartTapped(sender:UIButton) {
        if self.isCallViewController == "Specials"{
            self.addProductToCurrentCart(dictDate)
        }else if self.isCallViewController == "Wishlist" {
            self.addProductToCurrentCart(dictDate)
        }
    }

    @IBAction func btnAddToWishlistTapped(sender:UIButton) {
        if self.isCallViewController == "Specials"{
            self.addProductToWishLists(dictDate)
        }else if self.isCallViewController == "Wishlist" {
            self.removeProductFromWishLists(dictDate, successBlock: { () -> () in
                self.arrCellTitle.removeAllObjects()
                self.arrCellContent.removeAllObjects()
                self.txtView.text = ""
                //self.imgView.image = UIImage(imageLiteral: "")
                self.tblProductDetail.reloadData()
                //self.navigationController?.popViewControllerAnimated(true)
                }, failureBlock: { () -> () in

            })
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCellTitle.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellObj = tableView.dequeueReusableCellWithIdentifier("ProductCellIdentifile")! as UITableViewCell
        cellObj.textLabel?.text = arrCellTitle.objectAtIndex(indexPath.row) as? String
        cellObj.textLabel?.textColor = UIColor.appCellTitleColor()
        cellObj.textLabel?.font = UIFont.boldFontOfSize(12)
        cellObj.textLabel?.numberOfLines = 0

        cellObj.detailTextLabel?.text = arrCellContent.objectAtIndex(indexPath.row) as? String
        cellObj.detailTextLabel?.textColor = UIColor.appCellSubTitleColor()
        cellObj.detailTextLabel?.font = UIFont.normalFontOfSize(12)
        cellObj.detailTextLabel?.numberOfLines = 0
        
        return cellObj
    }
    
    
    
}
