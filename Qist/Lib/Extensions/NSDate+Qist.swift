//
//  NSDate+Qist.swift
//  Qist
//
//  Created by GrepRuby3 on 16/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

extension NSDate {
    
    public func getComponent (component : NSCalendarUnit) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(component, fromDate: self)
        return components.valueForComponent(component)
    }
    
    public func currentYear() -> Int {
        return getComponent(.Year)
    }
    
    public func currentMonth() -> Int {
        return getComponent(.Month)
    }
    
    public func currentWeekday() -> Int {
        return getComponent(.Weekday)
    }
    
    public func currentWeekMonth() -> Int {
        return getComponent(.WeekOfMonth)
    }

    func getDateFormate(today:String)->String? {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.dateFromString(today) {
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            let strFormatedDate = formatter.stringFromDate(todayDate)
            return strFormatedDate
        } else {
            return ""
        }
    }


}

