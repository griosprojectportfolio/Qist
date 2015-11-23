//
//  LeftPanelCell.swift
//  Qist
//
//  Created by GrepRuby3 on 21/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

class LeftPanelCell : UITableViewCell {

    var lblTitle : UILabel = UILabel()
    var iconImageView: UIImageView = UIImageView()
    var sepImgView: UIImageView = UIImageView()
    
    
    func configureCellAtIndexPath(indexPath:NSIndexPath){
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        if preSeleIndexPath == indexPath {
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        }else {
            self.backgroundColor = UIColor.clearColor()
        }
        
        iconImageView.frame = CGRectMake(20, 5, 25, 25)
        iconImageView.layer.masksToBounds = true
        self.addSubview(self.iconImageView)
        
        lblTitle.frame = CGRectMake(55, 0, 200, 35)
        lblTitle.textColor = UIColor.whiteColor()
        lblTitle.textAlignment = .Left
        lblTitle.font = UIFont.boldFontOfSize(14.0)
        self.addSubview(self.lblTitle)
        
        sepImgView.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)
        sepImgView.image = UIImage(named: "sidebar_divider")
        self.addSubview(self.sepImgView)
        
        if indexPath.section == 1 {
            if indexPath.row != 2 {
                iconImageView.frame = CGRectMake(20, 5, 15, 25)
            }else {
                iconImageView.frame = CGRectMake(20, 8, 20, 20)
            }
        }
    }
    
    func setupCellContentWithTitle_imageName( strTitle : String , imgName : String){
        self.lblTitle.text = strTitle
        self.iconImageView.image = UIImage(named: imgName)
    }
    
}