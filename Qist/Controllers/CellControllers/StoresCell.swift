//
//  StoresCell.swift
//  Qist
//
//  Created by GrepRuby3 on 23/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

protocol storeCellDelegate {
    func favouriteAndUnfavouriteTapped(intTag : Int)
}

class StoresCell : UITableViewCell {

    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnHeart: UIButton!
    @IBOutlet var storeImgView: UIImageView!

    var storeDelegate: storeCellDelegate?

    func configureStoreTableViewCell(){

        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()

        lblTitle.textColor = UIColor.whiteColor()
        lblTitle.textAlignment = .Left
        lblTitle.textColor = UIColor.appCellTitleColor()
        lblTitle.font = UIFont.appCellTitleFont()

        lblSubTitle.textColor = UIColor.whiteColor()
        lblSubTitle.textAlignment = .Left
        lblSubTitle.textColor = UIColor.appCellSubTitleColor()
        lblSubTitle.font = UIFont.appCellSubTitleFont()

    }

    func setupStoreCellContent(dictData: NSDictionary){


        let imgurl : NSURL = NSURL(string: dictData["logo_url"] as! String)!

        self.storeImgView.sd_setImageWithURL(imgurl, placeholderImage:UIImage(named: "No_image"))

        if let title : String = dictData["trading_name"] as? String {
            self.lblTitle.text = title
        }else {
            self.lblTitle.text = ""
        }
        if address(dictData) != "" {
            self.lblSubTitle.text = address(dictData)
        }else {
            self.lblSubTitle.text = ""
        }
    }

    @IBAction func heartButtonTapped(sender: UIButton){
        self.storeDelegate?.favouriteAndUnfavouriteTapped(self.tag)
    }

    func address(dict:NSDictionary)-> String {
        var address,suburb,city,zip : String!

        if dict.valueForKey("address") != nil {
            address = dict.valueForKey("address") as? String
        }else {
            address = ""
        }

        if dict.valueForKey("suburb") != nil {
            suburb = dict.valueForKey("suburb") as? String
        }else {
            suburb = ""
        }

        if dict.valueForKey("city") != nil {
            city = dict.valueForKey("city") as? String
        }else {
            city = ""
        }

        if dict.valueForKey("zip") != nil {
            zip = dict.valueForKey("zip") as? String
        }else {
            zip = ""
        }
        let full_Addess : String!
        if address != nil && suburb != nil && city != nil && zip != nil {
           full_Addess  = address + "," + suburb + "," + city + " " + zip
        }else {
            full_Addess = ""
        }

        return full_Addess
    }
    
    
}