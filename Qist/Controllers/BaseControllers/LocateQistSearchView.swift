//
//  LocateQistSearchView.swift
//  Qist
//
//  Created by GrepRuby3 on 28/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

protocol locateQistSearchDelegate {
    func searchQistForAddressTapped(strAddress : String)
}

class LocateQistSearchView : UIView , UITextFieldDelegate {

    var bgImgView : UIImageView!
    var gpsImgView : UIImageView!
    var searchTxtField : UITextField!
    var btnSearch : UIButton = UIButton(type: UIButtonType.Custom)
    var locateQistDelegate: locateQistSearchDelegate?
    
    // MARK: - Initialze view
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRectMake(frame.origin.x, frame.origin.y , frame.size.width, frame.size.height)
        self.applyDefaults(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyDefaults(frame:CGRect){
        
        self.bgImgView = UIImageView(frame: CGRectMake(frame.origin.x, 0 , frame.size.width, frame.size.height))
        self.bgImgView.image = UIImage(named: "navigation_bar")
        self.bgImgView.userInteractionEnabled = true
        self.addSubview(self.bgImgView)
        
        let iconLocationContainer : UIImageView = UIImageView(frame: CGRectMake(frame.origin.x, 0 , 39, 29))
        self.gpsImgView = UIImageView(frame: CGRectMake(frame.origin.x , 5 , 20 , 20))
        self.gpsImgView.image = UIImage(named: "icon_locate")
        let iconLocation : UIImageView = UIImageView(frame: CGRectMake(frame.origin.x, 0 , 29, 29))
        iconLocation.backgroundColor = UIColor.appSegmentBackgroundColor()
        iconLocation.addSubview(self.gpsImgView)
        iconLocationContainer.addSubview(iconLocation)
        
        self.btnSearch.frame = CGRectMake(frame.origin.x, 5 , 20 , 20)
        self.btnSearch.setBackgroundImage(UIImage(named: "locate_icon_search"), forState: UIControlState.Normal)
        let iconSearch : UIImageView = UIImageView(frame: CGRectMake(frame.origin.x, 0 , 29, 29))
        iconSearch.userInteractionEnabled = true
        iconSearch.addSubview(self.btnSearch)
        
        self.searchTxtField = UITextField(frame: CGRectMake(frame.origin.x + 40, 3 , frame.size.width - 80, 29))
        self.searchTxtField.background = UIImage(named: "locate_text_field")
        self.searchTxtField.leftView = iconLocationContainer
        self.searchTxtField.leftViewMode = UITextFieldViewMode.Always
        self.searchTxtField.rightView = iconSearch
        self.searchTxtField.rightViewMode = UITextFieldViewMode.Always
        self.searchTxtField.returnKeyType = UIReturnKeyType.Search
        self.searchTxtField.delegate = self
        self.searchTxtField.font = UIFont.normalFontOfSize(14.0)
        self.searchTxtField.attributedPlaceholder = NSAttributedString(string:"ENTER ADDRESS", attributes:[NSForegroundColorAttributeName: UIColor.appCellSubTitleColor()])
        self.bgImgView.addSubview(self.searchTxtField)
        
    }
    
    func addTopSearchQistLocationOnView(viewController: UIViewController){
        viewController.view.addSubview(self)
    }
    
    
    // MARK: - Text Field Delegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.locateQistDelegate?.searchQistForAddressTapped(textField.text!)
        return false
    }
    
}
