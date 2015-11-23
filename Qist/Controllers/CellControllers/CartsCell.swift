//
//  CartsCell.swift
//  Qist
//
//  Created by GrepRuby3 on 25/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class CartsCell : UITableViewCell {
    
    @IBOutlet var prodImgView: UIImageView!
    @IBOutlet var lblProductName : UILabel!
    @IBOutlet var lblProductPay: UILabel!
    @IBOutlet var lblProductMrp: UILabel!
    @IBOutlet var lblProductSave: UILabel!
    
    @IBOutlet var btnRemoveFromWishList: UIButton!
    @IBOutlet var btnAddToCart: UIButton!
    
    @IBOutlet var lblProductExp: UILabel!
    
    func configureCartsTableViewCell(){
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()
        
        prodImgView.layer.borderWidth = 1
        prodImgView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        lblProductName.textAlignment = .Left
        lblProductName.textColor = UIColor.appCellSubTitleColor()
        lblProductName.font = UIFont.boldFontOfSize(14.0)
        
        lblProductPay.textAlignment = .Left
        lblProductPay.textColor = UIColor.appCellTitleColor()
        lblProductPay.font = UIFont.boldFontOfSize(14.0)
        
        lblProductMrp.textAlignment = .Left
        lblProductMrp.textColor = UIColor.appCellSubTitleColor()
        lblProductMrp.font = UIFont.normalFontOfSize(11.0)
        
        lblProductSave.textAlignment = .Left
        lblProductSave.textColor = UIColor.appCellSubTitleColor()
        lblProductSave.font = UIFont.normalFontOfSize(11.0)
        
        lblProductExp.textAlignment = .Left
        lblProductExp.textColor = UIColor.appCellSubTitleColor()
        lblProductExp.font = UIFont.normalFontOfSize(08.0)
        
    }
    
    func setupCartsCellContent(){
        
        self.lblProductName.text = "Beats Headphone"
        self.lblProductPay.text = "You Pay $450"
        self.lblProductMrp.text = "MRP : $500"
        self.lblProductSave.text = "Save : 10%"
        self.prodImgView.image = UIImage(named: "hamburger")
        
    }
    
}