//
//  StoreDetailsController.swift
//  Qist
//
//  Created by GrepRuby on 03/02/16.
//  Copyright © 2016 GrepRuby3. All rights reserved.
//

import UIKit

class StoreDetailsController: BaseController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var imgView : UIImageView!
    @IBOutlet var tblSotreDetail : UITableView!

    var dictDate : NSDictionary!

    var arrCellTitle  : NSArray = NSArray(objects: "Store Name","Address","Business","Contact Person","Contact No")
    var arrCellContent : NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        print(dictDate)
        self.title = dictDate["trading_name"] as? String
        dataNilCheck()
    }

    func dataNilCheck() {
        if let storeName = dictDate["trading_name"] as? String {
            arrCellContent.addObject(storeName)
        }else{
            arrCellContent.addObject("")
        }

        if let address = dictDate["location"] as? String {
            arrCellContent.addObject(address)
        }else{
            arrCellContent.addObject("")
        }

        if let business_name = dictDate["business_name"] as? String {
            arrCellContent.addObject(business_name)
        }else{
            arrCellContent.addObject("")
        }

        if let contact_person = dictDate["contact_person"] as? String {
            arrCellContent.addObject(contact_person)
        }else{
            arrCellContent.addObject("")
        }

        if let mobile_no = dictDate["mobile_no"] as? String {
            arrCellContent.addObject(mobile_no)
        }else{
            arrCellContent.addObject("")
        }

        let arrKeys = dictDate.allKeys as NSArray
        if arrKeys.containsObject("logo_url") {
            let imgUrl : NSURL = NSURL(string: (dictDate.valueForKey("logo_url") as! String))!
            imgView.sd_setImageWithURL(imgUrl, placeholderImage: UIImage(named: "No_image"))
        }else {
            imgView.image = UIImage(named: "No_image")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup befour appear the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after appear the view.
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCellTitle.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellObj = tableView.dequeueReusableCellWithIdentifier("storedetail")! as UITableViewCell
        cellObj.textLabel?.text = arrCellTitle.objectAtIndex(indexPath.row) as? String
        cellObj.textLabel?.textColor = UIColor.appCellTitleColor()
        cellObj.textLabel?.font = UIFont.boldFontOfSize(12)
        cellObj.textLabel?.numberOfLines = 0

        cellObj.detailTextLabel?.text = arrCellContent.objectAtIndex(indexPath.row) as? String
        cellObj.detailTextLabel?.textColor = UIColor.appCellSubTitleColor()
        cellObj.detailTextLabel?.font = UIFont.normalFontOfSize(12)
        cellObj.detailTextLabel?.numberOfLines = 0
        
        return cellObj
    }
    
    // MARK: -  Overrided Methods of BaseController
    override func leftNavBackButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func configureComponentsLayout(){
        // This function use for set layout of components.
    }

    override func assignDataToComponents(){
        // This function use for assign data to components.
    }

    
}
