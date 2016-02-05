//
//  WishListsCell.swift
//  Qist
//
//  Created by GrepRuby3 on 25/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

protocol wishlistsCellDelegate {
    func removeProductFromWishListsTapped(Indexpath : NSIndexPath)
    func addProductToCartsTapped(Indexpath : NSIndexPath)
}

class WishListsCell : UITableViewCell {
    
    @IBOutlet var prodImgView: UIImageView!
    @IBOutlet var lblProductName : UILabel!
    @IBOutlet var lblProductPay: UILabel!
    @IBOutlet var lblProductMrp: UILabel!
    @IBOutlet var lblProductSave: UILabel!
    
    @IBOutlet var btnRemoveFromWishList: UIButton!
    @IBOutlet var btnAddToCart: UIButton!
    
    @IBOutlet var lblProductExp: UILabel!
    
    var wishlistsDelegate: wishlistsCellDelegate?
    var cellIndexpath : NSIndexPath!
    
    
    func configureWishListsTableViewCell(){
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()
        
        prodImgView.layer.borderWidth = 1
        prodImgView.layer.borderColor = UIColor.lightGrayColor().CGColor

        lblProductName.textAlignment = .Left
        lblProductName.textColor = UIColor.appCellSubTitleColor()
        lblProductName.font = UIFont.boldFontOfSize(13.0)
        
        lblProductPay.textAlignment = .Left
        lblProductPay.textColor = UIColor.appCellTitleColor()
        lblProductPay.font = UIFont.boldFontOfSize(13.0)
        
        lblProductMrp.textAlignment = .Left
        lblProductMrp.textColor = UIColor.appCellSubTitleColor()
        lblProductMrp.font = UIFont.normalFontOfSize(10.0)
        
        lblProductSave.textAlignment = .Left
        lblProductSave.textColor = UIColor.appCellSubTitleColor()
        lblProductSave.font = UIFont.normalFontOfSize(10.0)
        
        lblProductExp.textAlignment = .Left
        lblProductExp.textColor = UIColor.appCellSubTitleColor()
        lblProductExp.font = UIFont.normalFontOfSize(10.0)

    }
    
    func setupWishListsCellContent(dict:NSDictionary,indexpath:NSIndexPath){
        
        if let ProductName : String = dict["name"] as? String {
            self.lblProductName.text = ProductName
        }
        
        if let ProductMrp : String = dict["original_price"] as? String {
            self.lblProductMrp.text = "MRP: " + ProductMrp
        }
        
        if let ProductPay : String = dict["qist_price"] as? String {
            self.lblProductPay.text = "You Pay: " + ProductPay
        }
        self.prodImgView.sd_setImageWithURL(NSURL(fileURLWithPath: ""), placeholderImage:UIImage(named: "No_image"))
        cellIndexpath = indexpath
        lblProductExp.text = "Expires: " + NSDate().getDateFormate((dict["valid_to_date"] as? String)!)!
    }
 
    @IBAction func removeFromWishlistTapped(sender: UIButton){
        self.wishlistsDelegate?.removeProductFromWishListsTapped(cellIndexpath)
    }
    
    @IBAction func addToCartsTapped(sender: UIButton){
        self.wishlistsDelegate?.addProductToCartsTapped(cellIndexpath)
    }
    
}
