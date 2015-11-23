//
//  SegmentedView.swift
//  Qist
//
//  Created by GrepRuby3 on 24/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

protocol segmentedTapActionDelegate {
    func leftSegmentTappedAction()
    func rightSegmentTappedAction()
}

class SegmentedView : UIView {

    var leftButton : UIButton = UIButton(type: UIButtonType.Custom)
    var rightButton : UIButton = UIButton(type: UIButtonType.Custom)
    var delegate: segmentedTapActionDelegate?
    
    // MARK: - Initialze view
    init(frame: CGRect,leftBtnTitle:String, rightBtnTitle:String) {
        super.init(frame: frame)
        self.frame = CGRectMake(frame.origin.x, frame.origin.y , frame.size.width, frame.size.height)
        self.backgroundColor = UIColor.appSegmentBackgroundColor()
        self.applyDefaults(frame,leftSegmentTitle:leftBtnTitle, rightSegmentTitle:rightBtnTitle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyDefaults(frame:CGRect,leftSegmentTitle:String, rightSegmentTitle:String){
        
        self.leftButton.frame = CGRectMake(frame.origin.x, 0, frame.size.width/2, frame.size.height)
        self.leftButton.setTitle(leftSegmentTitle, forState: UIControlState.Normal)
        self.leftButton.titleLabel?.font = UIFont.appSegmentedButtonTitleFont()
        self.leftButton.backgroundColor = UIColor.appSelectedSegmentColor()
        self.leftButton.addTarget(self, action: Selector("leftSegmentedButtonTapped:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.leftButton)

        self.rightButton.frame = CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height)
        self.rightButton.setTitle(rightSegmentTitle, forState: UIControlState.Normal)
        self.rightButton.titleLabel?.font = UIFont.appSegmentedButtonTitleFont()
        self.rightButton.addTarget(self, action: Selector("rightSegmentedButtonTapped:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.rightButton)
    }
    
    func leftSegmentedButtonTapped(sender:UIButton){
        self.leftButton.backgroundColor = UIColor.appSelectedSegmentColor()
        self.rightButton.backgroundColor = UIColor.clearColor()
        self.delegate?.leftSegmentTappedAction()
    }
    
    func rightSegmentedButtonTapped(sender:UIButton){
        self.rightButton.backgroundColor = UIColor.appSelectedSegmentColor()
        self.leftButton.backgroundColor = UIColor.clearColor()
        self.delegate?.rightSegmentTappedAction()
    }
    
    func addTopSegmentedButtonOnView(viewController: UIViewController){
        viewController.view.addSubview(self)
    }
    
}