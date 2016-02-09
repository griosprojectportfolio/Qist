//
//  ProfileCell.swift
//  Qist
//
//  Created by GrepRuby3 on 28/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

protocol ProfileCellDelegates {
    func btnChangetapped(index:NSInteger)
}


class ProfileCell : UITableViewCell {

    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnChange: UIButton!

    var delegates:ProfileCellDelegates!

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

    func setupProfileCellContentAt_IndexPath(indexPath:NSIndexPath,objUser:User){

        btnChange.tag = indexPath.row

        switch indexPath.row {

        case 0 :    self.lblTitle.text = "First Name"
        self.lblSubTitle.text = objUser.first_name!

        case 1 :    self.lblTitle.text = "Last Name"
        self.lblSubTitle.text = objUser.last_name!

        case 2 :    self.lblTitle.text = "DOB"
        if objUser.dob != nil {
            let strDob = objUser.dob! as String
            let index1 = strDob.endIndex.advancedBy(-9)
            let substring1 = strDob.substringToIndex(index1)
            self.lblSubTitle.text = NSDate().getDobWithFormateString(substring1)
        }else {
            self.lblSubTitle.text = ""
            }

        case 3 :    self.lblTitle.text = "Email Address"
        self.lblSubTitle.text = objUser.email
        self.btnChange.hidden = true

        case 4 :    self.lblTitle.text = "Password"
        self.lblSubTitle.text = "****"

        case 5 :    self.lblTitle.text = "Your Location"
        self.lblSubTitle.text = objUser.address_1
        self.btnChange.hidden = true

        default :   self.lblTitle.text = ""
        self.lblSubTitle.text = ""
        }
    }
    
    @IBAction func btnChangeTap(sender:UIButton) {
        delegates.btnChangetapped(sender.tag)
    }
}