//
//  UIFont+Qist.swift
//  Qist
//
//  Created by GrepRuby3 on 16/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    // MARK: - System Fonts methods
    class func defaultFontOfSize(size: CGFloat) -> UIFont {
        return systemFontOfSize(size)
    }
    
    // MARK: - Custom Font methods
    class func normalFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: size)!
    }
    
    class func italicFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Italic", size: size)!
    }
    
    class func boldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: size)!
    }
    
    class func mediumFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Medium", size: size)!
    }
    
    class func lightFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: size)!
    }
    
    class func thinFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Thin", size: size)!
    }
    
    class func ultraLightFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-UltraLight", size: size)!
    }
    
    
    // MARK: - Custom Font methods
    class func QistTextFieldFont() -> UIFont {
        return UIFont(name: "Palatino", size: 17.0)!
    }
    
    // MARK: - Qist Table Cell
    class func appCellTitleFont() -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: 14.0)!
    }
    
    class func appCellSubTitleFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 12.0)!
    }
    
    // MARK: - Qist Segmented Control
    class func appSegmentedButtonTitleFont() -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: 15.0)!
    }
}

