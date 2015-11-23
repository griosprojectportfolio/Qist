//
//  ProfileCell.swift
//  Qist
//
//  Created by GrepRuby3 on 28/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class ProfileCell : UITableViewCell {
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnChangeCart: UIButton!
    
    func configureProfileTableViewCell(){
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()
        
        lblTitle.textAlignment = .Left
        lblTitle.textColor = UIColor.appCellTitleColor()
        lblTitle.font = UIFont.boldFontOfSize(16.0)
        
        lblSubTitle.textAlignment = .Left
        lblSubTitle.textColor = UIColor.grayColor()
        lblSubTitle.font = UIFont.normalFontOfSize(13.0)
    }

    func setupHistoryCellContentAt_IndexPath(indexPath:NSIndexPath,objProfile:NSDictionary){
        switch indexPath.row {
        case 0 :    self.lblTitle.text = "Name"
                    self.lblSubTitle.text = objProfile["name"] as? String
        case 1 :    self.lblTitle.text = "Email Address"
                    self.lblSubTitle.text = objProfile["email"] as? String
        case 2 :    self.lblTitle.text = "Password"
                    self.lblSubTitle.text = objProfile["password"] as? String
        case 3 :    self.lblTitle.text = "Your Location"
                    self.lblSubTitle.text = objProfile["location"] as? String
        default :   self.lblTitle.text = ""
                    self.lblSubTitle.text = ""
        }
    }
}