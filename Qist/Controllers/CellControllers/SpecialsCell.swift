//
//  SpecialsCell.swift
//  Qist
//
//  Created by GrepRuby3 on 24/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class SpecialsCell : UITableViewCell {
    
    @IBOutlet var lblStoreName : UILabel!
    @IBOutlet var lblProductName : UILabel!
    @IBOutlet var lblProductPay: UILabel!
    @IBOutlet var lblProductMrp: UILabel!
    @IBOutlet var lblProductSave: UILabel!
    @IBOutlet var btnAddToWishList: UIButton!
    @IBOutlet var btnAddToCart: UIButton!
    @IBOutlet var prodImgView: UIImageView!
    
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
    
    func setupStoreCellContent(){
        
        self.lblStoreName.text = "Special 1 - Apple Store, Southland"
        self.lblProductName.text = "Beats Headphone"
        self.lblProductPay.text = "You Pay $450"
        self.lblProductMrp.text = "MRP : $500"
        self.lblProductSave.text = "Save : 10%"
        self.prodImgView.image = UIImage(named: "hamburger")
        
    }
    
}