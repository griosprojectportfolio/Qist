//
//  ScanProductController.swift
//  Qist
//
//  Created by GrepRuby3 on 06/10/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class ScanProductController : BaseController,UITableViewDelegate,UITableViewDataSource,ScanProductCellDelegates {
    
    @IBOutlet var lblCurrentStore: UILabel!
    @IBOutlet var lblCurrentDate: UILabel!
    
    @IBOutlet var tblScanProduct: UITableView!

    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "PRODUCT"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup befour appear the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after appear the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        // This function use for set layout of components.
        if isiPhone5 || isiPhone4s {
            self.lblCurrentStore.font = UIFont.defaultFontOfSize(12.0)
            self.lblCurrentDate.font = UIFont.defaultFontOfSize(12.0)
        }
    }
    
    override func assignDataToComponents(){
        // This function use for assign data to components.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellObj = tableView.dequeueReusableCellWithIdentifier("ScanProduct") as! ScanProductCell
        cellObj.productDelegates = self
        return cellObj
    }
    
    // MARK: - specialsCellDelegate methods
    func addProductToWishListTapped(Indexpath: NSIndexPath) {
//        print("Cell object == \(self.isJustForYou ? self.arrJustForYou[intTag] as! NSDictionary : self.arrSpecials[intTag] as! NSDictionary)")
//        let dict = arrSpecials.objectAtIndex(intTag) as! NSDictionary
//        self.addProductToWishLists(dict)
    }
    
    func addProductToCartsTapped(Indexpath: NSIndexPath) {
//        print("Cell object == \(self.isJustForYou ? self.arrJustForYou[intTag] as! NSDictionary : self.arrSpecials[intTag] as! NSDictionary)")
//        let dict = arrSpecials.objectAtIndex(intTag) as! NSDictionary
//        self.addProductToCurrentCart(dict)
    }
    
}