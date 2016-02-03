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
        if let subTitle : String = dictData["location"] as? String {
            self.lblSubTitle.text = subTitle
        }else{
            self.lblSubTitle.text = ""
        }
        
    }
    
    @IBAction func heartButtonTapped(sender: UIButton){
        self.storeDelegate?.favouriteAndUnfavouriteTapped(self.tag)
    }
    
}