//
//  CheckOutView.swift
//  Qist
//
//  Created by GrepRuby3 on 25/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

protocol checkOutTapActionDelegate {
    func checkOutButtonTappedAction()
}

class CheckOutView : UIView {
    
    var totalImgView : UIImageView = UIImageView()
    var lblTotal : UILabel = UILabel()
    var lblTotalAmount : UILabel = UILabel()
    var sepImgView : UIImageView = UIImageView()
    var lblSavedAnount : UILabel = UILabel()
    var btnCheckOut : UIButton = UIButton(type: UIButtonType.Custom)
    var delegate: checkOutTapActionDelegate?
    
    // MARK: - Initialze view
    init(frame:CGRect,totalAmount:String,savedAmount:String) {
        super.init(frame: frame)
        self.frame = CGRectMake(frame.origin.x, frame.origin.y , frame.size.width, frame.size.height)
        self.backgroundColor = UIColor.clearColor()
        self.applyDefaults(frame,strTotalAmount:totalAmount, strSavedAmount:savedAmount)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyDefaults(frame:CGRect,strTotalAmount:String,strSavedAmount:String){
        
        self.totalImgView.frame = CGRectMake(frame.origin.x, 0, frame.size.width, 20)
        self.totalImgView.image = UIImage(named: "total_bg")
        self.lblTotal.frame = CGRectMake(frame.origin.x + 15, 0, frame.size.width, 20)
        self.lblTotal.text = "TOTAL"
        self.lblTotal.font = UIFont.defaultFontOfSize(12)
        self.lblTotal.textColor = UIColor.whiteColor()
        self.totalImgView.addSubview(self.lblTotal)
        self.addSubview(self.totalImgView)

        self.lblTotalAmount.frame = CGRectMake(frame.origin.x + 15, 22, frame.size.width - 30, 20)
        self.lblTotalAmount.font = UIFont.defaultFontOfSize(15)
        self.lblTotalAmount.textColor = UIColor.appCellSubTitleColor()
        self.lblTotalAmount.text = "Total Amount : \(strTotalAmount)"
        self.addSubview(self.lblTotalAmount)
        
        self.sepImgView.frame = CGRectMake(frame.origin.x + 15, 45, frame.size.width - 30, 1)
        self.sepImgView.image = UIImage(named: "divider")
        self.addSubview(self.sepImgView)

        self.lblSavedAnount.frame = CGRectMake(frame.origin.x + 15, 46, frame.size.width - 30, 20)
        self.lblSavedAnount.font = UIFont.defaultFontOfSize(15)
        self.lblSavedAnount.textColor = UIColor.appCellSubTitleColor()
        self.lblSavedAnount.text = "You Saved : \(strSavedAmount)"
        self.addSubview(self.lblSavedAnount)
        
        self.btnCheckOut.frame = CGRectMake((frame.size.width/2) - 60, 76 , 120, 35)
        self.btnCheckOut.setImage(UIImage(named: "button_checkout"), forState: UIControlState.Normal)
        self.btnCheckOut.addTarget(self, action: Selector("checkOutButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.btnCheckOut)
    }
    
    func checkOutButtonTapped() {
    delegate?.checkOutButtonTappedAction()
    }
    
}