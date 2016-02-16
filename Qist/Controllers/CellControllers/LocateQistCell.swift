//
//  LocateQistCell.swift
//  Qist
//
//  Created by GrepRuby3 on 28/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

protocol locateQistCellDelegate {
    func favouriteButtonTapped(intTag:Int)
}

class LocateQistCell : UITableViewCell {
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnHeart: UIButton!
    @IBOutlet var storeImgView: UIImageView!
    
    var locateCellDelegate: locateQistCellDelegate?
    
    func configureLocateQistTableViewCell(){
        
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
    
    func setupLocateQistCellContent(dictData : NSDictionary){
        
        if let title : String = dictData["trading_name"] as? String {
            self.lblTitle.text = title
        }
        if let subTitle : String = dictData["location"] as? String {
            self.lblSubTitle.text = self.address(dictData)
        }
        self.storeImgView.sd_setImageWithURL(NSURL(string:""), placeholderImage:UIImage(named: "No_image"))

    }
    
    @IBAction func heartButtonTapped(sender: UIButton){
        self.locateCellDelegate?.favouriteButtonTapped(self.tag)
    }

    func address(dict:NSDictionary)-> String {
        var address,suburb,city,zip : String!

        if dict.valueForKey("address") != nil {
            address = dict.valueForKey("address") as! String
        }else {
            address = ""
        }

        if dict.valueForKey("suburb") != nil {
            suburb = dict.valueForKey("suburb") as! String
        }else {
            suburb = ""
        }

        if dict.valueForKey("city") != nil {
            city = dict.valueForKey("city") as! String
        }else {
            city = ""
        }

        if dict.valueForKey("zip") != nil {
            zip = dict.valueForKey("zip") as! String
        }else {
            zip = ""
        }
        let full_Addess : String = address + "," + suburb + "," + city + " " + zip
        return full_Addess
    }

}