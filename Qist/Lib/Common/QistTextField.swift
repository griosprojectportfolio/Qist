//
//  QistTextField.swift
//  Qist
//
//  Created by GrepRuby3 on 16/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

class QistTextField : UITextField {
    
    func setupTextFieldBasicProperty(imgName: String , isSecureEntery : Bool) {
        
        if !imgName.isEmpty {
            
            let imageName = imgName
            let image = UIImage(named:imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 11, y: 9, width: 22, height: 22)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            let vwImage = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: 40))
            vwImage.addSubview(imageView)
            self.returnKeyType = UIReturnKeyType.Done
            self.leftView = vwImage
            self.leftViewMode = UITextFieldViewMode.Always
            self.backgroundColor = UIColor.clearColor()
            self.font = UIFont.QistTextFieldFont()
            self.textColor = UIColor.appBackgroundColor()
            self.clearButtonMode = UITextFieldViewMode.WhileEditing
            if isSecureEntery{
                self.secureTextEntry = true
            }
            
        } else {
            let vwImage = UIView(frame:CGRect(x: 0, y: 0, width: 10, height: 5))
            self.returnKeyType = UIReturnKeyType.Done
            self.leftView = vwImage
            self.leftViewMode = UITextFieldViewMode.Always
            self.backgroundColor = UIColor.clearColor()
            self.font = UIFont.QistTextFieldFont()
            self.textColor = UIColor.appBackgroundColor()
            self.clearButtonMode = UITextFieldViewMode.WhileEditing
            if isSecureEntery{
                self.secureTextEntry = true
            }
        }
    }
    
    func animateCurrentViewUpAndDownSide(up:Bool, moveValue :CGFloat, viewController : UIViewController){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        viewController.view.frame = CGRectOffset(viewController.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
}
