//
//  SpecialsCell.swift
//  Qist
//
//  Created by GrepRuby3 on 24/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

protocol specialsCellDelegate {
    func addProductToWishlistsTapped(intTag : Int)
    func addProductToCartsTapped(intTag : Int)
}

class SpecialsCell : UITableViewCell {
    
    @IBOutlet var lblStoreName : UILabel!
    @IBOutlet var lblProductName : UILabel!
    @IBOutlet var lblProductPay: UILabel!
    @IBOutlet var lblProductMrp: UILabel!
    @IBOutlet var lblProductSave: UILabel!
    @IBOutlet var btnAddToWishList: UIButton!
    @IBOutlet var btnAddToCart: UIButton!
    @IBOutlet var prodImgView: UIImageView!
    
    var specialsDelegate: specialsCellDelegate?
    
    func configureStoreTableViewCell(){
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()
        
        lblStoreName.textAlignment = .Left
        lblStoreName.textColor = UIColor.appCellTitleColor()
        lblStoreName.font = UIFont.boldFontOfSize(14.0)
        
        lblProductName.textAlignment = .Left
        lblProductName.textColor = UIColor.appCellSubTitleColor()
        lblProductName.font = UIFont.boldFontOfSize(13.0)
        
        lblProductPay.textAlignment = .Left
        lblProductPay.textColor = UIColor.appCellTitleColor()
        lblProductPay.font = UIFont.boldFontOfSize(13.0)
        
        lblProductMrp.textAlignment = .Left
        lblProductMrp.textColor = UIColor.appCellSubTitleColor()
        lblProductMrp.font = UIFont.normalFontOfSize(11.0)
        
        lblProductSave.textAlignment = .Left
        lblProductSave.textColor = UIColor.appCellSubTitleColor()
        lblProductSave.font = UIFont.normalFontOfSize(11.0)
        
        prodImgView.layer.borderWidth = 1
        prodImgView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
    }
    
    func setupSpecialsCellContent(dictData : NSDictionary){
        
        self.lblStoreName.text = ""
        
        if let prodName : String = dictData["name"] as? String {
            self.lblProductName.text = prodName
        }
        if let original_price : String = dictData["original_price"] as? String {
            self.lblProductMrp.text = "MRP : $\(original_price)"
        }
        if let qist_price : String = dictData["qist_price"] as? String {
            self.lblProductPay.text = "Qist Price: $\(qist_price)"
        }
        self.prodImgView.sd_setImageWithURL(NSURL(fileURLWithPath: ""), placeholderImage:UIImage(named: "No_image"))
    }
    
    @IBAction func addToWishlistTapped(sender: UIButton){
        self.specialsDelegate?.addProductToWishlistsTapped(self.tag)
    }
    
    @IBAction func addToCartsTapped(sender: UIButton){
        self.specialsDelegate?.addProductToCartsTapped(self.tag)
    }
    
}