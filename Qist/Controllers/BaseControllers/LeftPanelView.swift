//
//  LeftPanelView.swift
//  Qist
//
//  Created by GrepRuby3 on 23/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

var preSeleIndexPath : NSIndexPath = NSIndexPath()

protocol leftPanelDelegate {
    func getSelectedSectionWithRow(intSection:Int,intRow:Int,fromController: UIViewController)
}


class LeftPanelView : UIView , UITableViewDelegate , UITableViewDataSource , UIGestureRecognizerDelegate {
    
    var tblBckImageView: UIImageView = UIImageView()
    var tblView : UITableView = UITableView()
    var tblWidth : CGFloat!
    var delegate: leftPanelDelegate?
    var isFromController : UIViewController = UIViewController()
    let objWindow:UIWindow = UIApplication.sharedApplication().delegate!.window!!

    
    let menuOtions : NSArray = [["STORES","CARTS","WISHLISTS","SPECIALS","LOCATE QIST","PROFILE","SETTINGS","HISTORY"],["ABOUT","SUPPORT","LOGOUT"]]
    let menuIcons : NSArray = [["sidebar_icon_store","sidebar_icon_cart","sidebar_icon_wishlist","sidebar_icon_special","sidebar_icon_locate","sidebar_icon_profile","sidebar_icon_setting","sidebar_icon_history"],["sidebar_icon_about","sidebar_icon_support","sidebar_icon_logout"]]
    
    
    // MARK: - Initialze view
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRectMake(frame.origin.x, frame.origin.y , -frame.size.width, frame.size.height)
        self.backgroundColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.applyDefaults(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyDefaults(frame: CGRect){
        
        self.tblWidth = frame.size.width - 100

        tblBckImageView.frame = CGRectMake(frame.origin.y , frame.origin.y - 5 , tblWidth, frame.size.height + 5)
        tblBckImageView.image = UIImage(named: "sidebar_bg")
        tblBckImageView.userInteractionEnabled = true
        tblBckImageView.layer.masksToBounds = true
        self.addSubview(tblBckImageView)
        
        self.tblView.frame = self.getTableFrameRect()
        self.tblView.registerClass(LeftPanelCell.self, forCellReuseIdentifier: "cell")
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.scrollEnabled = false
        self.tblView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tblView.backgroundColor = UIColor.clearColor()
        self.tblBckImageView.addSubview(tblView)
        
        if isiPhone4s {
            self.tblView.scrollEnabled = true
        }
        
        // Add left swipe gesture recognizer
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "removeLeftPanelFromSuperView")
        leftSwipeGestureRecognizer.delegate = self
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(leftSwipeGestureRecognizer)
    }
    
    
    // MARK: - TableView Delegate and Data Source Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.menuOtions.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuOtions[section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.getHeaderHeightForSection(section)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerImageView : UIImageView = UIImageView(frame: CGRectMake(0, 0, self.tblWidth , 95))
        headerImageView.backgroundColor = UIColor.clearColor()
        
        if section == 0 {
            if isiPhone6 {
                headerImageView.frame = CGRectMake(0, 0, self.tblWidth , 120)
            }else if isiPhone6plus {
                headerImageView.frame = CGRectMake(0, 0, self.tblWidth , 150)
            }else if isiPad {
                headerImageView.frame = CGRectMake(0, 0, self.tblWidth , 170)
            }
            let iconTap = UITapGestureRecognizer(target: self, action: Selector("topIconTapAction"))
            headerImageView.userInteractionEnabled = true
            headerImageView.addGestureRecognizer(iconTap)
            headerImageView.image = UIImage(named: "sidebar_scan")
        }
        return headerImageView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : LeftPanelCell = tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath:indexPath) as! LeftPanelCell
        cell.configureCellAtIndexPath(indexPath)
        let cellTitleText : String = (self.menuOtions[indexPath.section] as! NSArray)[indexPath.row] as! String
        let cellImageText : String = (self.menuIcons[indexPath.section] as! NSArray)[indexPath.row] as! String
        cell.setupCellContentWithTitle_imageName(cellTitleText , imgName: cellImageText)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        preSeleIndexPath = indexPath
        self.removeLeftPanelFromSuperView()
        self.delegate?.getSelectedSectionWithRow(indexPath.section, intRow:indexPath.row, fromController:isFromController)
    }
    
    
    // MARK: - Some common methods
    
    func getTableFrameRect() -> CGRect {
        var frameRect : CGRect = CGRect()
        if isiPad {
            frameRect = CGRectMake(0, 25 , self.tblWidth - 18 , frame.size.height)
        }else {
            frameRect = CGRectMake(0, 25 , self.tblWidth - 8 , frame.size.height)
        }
        return frameRect;
    }
    
    func getHeaderHeightForSection(section : Int) -> CGFloat {
        var height : CGFloat = 95.0
        if section == 0 {
            if isiPhone6 {
                height = 120
            }else if isiPhone6plus {
                height = 150
            }else if isiPad {
                height = 170
            }
        }else if section == 1 {
            if isiPhone6 {
                height = self.frame.size.height - 530
            }else if isiPhone6plus {
                height = self.frame.size.height - 560
            }else if isiPad {
                height = self.frame.size.height - 580
            }else {
                height = self.frame.size.height - 505
            }
        }
        return height
    }
    
    // MARK: - Toggle left view
    func toggleLeftPanel(viewController : UIViewController){
        
        isFromController = viewController
        objWindow.addSubview(self)
        
        UIView.animateWithDuration( 0.5, animations: { () -> Void in
            self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            },
            completion: { (Bool) -> Void in
        })
    }
    
    
    // MARK: - View Tap Gesture Method
    func removeLeftPanelFromSuperView() {
        
        UIView.animateWithDuration( 0.5, animations: { () -> Void in
            self.frame = CGRectMake(0, 0, -self.frame.size.width, self.frame.size.height)
            },
            completion: { (Bool) -> Void in
                self.removeFromSuperview()
        })
        
    }
    
    // MARK: - Top icon Tap Gesture Method
    func topIconTapAction() {
        self.removeLeftPanelFromSuperView()
        self.delegate?.getSelectedSectionWithRow(0, intRow: 8, fromController:isFromController)
    }
    
}
