//
//  ScanProductController.swift
//  Qist
//
//  Created by GrepRuby3 on 06/10/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class ScanProductController : BaseController,UITableViewDelegate,UITableViewDataSource,ScanProductCellDelegates {
    
    
    @IBOutlet var tblScanProduct: UITableView!
    var dictData : NSDictionary = NSDictionary()

    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "PRODUCT"
        print(dictData)
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
        cellObj.setupSpecialsCellContent(dictData, indexPath: indexPath)
        cellObj.lblYouSave.text = calculateSavingPercentage((dictData["qist_price"] as? String)!, originalPrice: (dictData["original_price"] as? String)!) as String + "%"
        return cellObj
    }
    
    // MARK: - specialsCellDelegate methods
    func addProductToWishListTapped(Indexpath: NSIndexPath) {
            self.addProductToWishLists(dictData)
    }
    
    func addProductToCartsTapped(Indexpath: NSIndexPath) {
            self.addProductToCurrentCart(dictData)
    }
    
}