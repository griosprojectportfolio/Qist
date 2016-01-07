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
        
        self.lblTitle.text = "Kirkcaldie & Stains"
        self.lblSubTitle.text = "Christchurch,Caterbury"
        self.storeImgView.image = UIImage(named: "hamburger")
        
    }
    
    @IBAction func heartButtonTapped(sender: UIButton){
        self.locateCellDelegate?.favouriteButtonTapped(self.tag)
    }

}