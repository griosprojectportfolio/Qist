//
//  CartsController.swift
//  Qist
//
//  Created by GrepRuby3 on 23/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class CartsController : BaseController , segmentedTapActionDelegate {
    
    @IBOutlet var lblCurrentStore: UILabel!
    @IBOutlet var lblCurrentDate: UILabel!
    
    @IBOutlet var tblCartsView : UITableView!
    var objCheckOutView : CheckOutView!
    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "CARTS"
        self.setupCheckOutViewDataContent()
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
    
    
    // MARK: - segmentedTapActionDelegate and their Delegate Methods
    func setupTopSegmentedControlOnView(){
        let segView : SegmentedView = SegmentedView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 64, self.view.frame.size.width, 35), leftBtnTitle: "CURRENT CART", rightBtnTitle: "WISHLIST")
        segView.delegate = self
        segView.addTopSegmentedButtonOnView(self)
    }
    
    func leftSegmentTappedAction() {
        self.tblCartsView?.frame = CGRectMake(self.tblCartsView!.frame.origin.x, self.tblCartsView!.frame.origin.y ,self.tblCartsView!.frame.size.width , self.view.frame.size.height - 310 )
        self.setupCheckOutViewDataContent()
    }
    
    func rightSegmentTappedAction() {
        self.tblCartsView?.frame = CGRectMake(self.tblCartsView!.frame.origin.x, self.tblCartsView!.frame.origin.y ,self.tblCartsView!.frame.size.width , self.view.frame.size.height - 190 )
        self.objCheckOutView.removeFromSuperview()
    }
    
    
    
    // MARK: - Setup top view Contents and Actions Methods
    func setupCartsTopViewDataContent(){
        
    }
    
    @IBAction func extendCartButtonTapped(sender: UIButton) {
        
    }
    
    
    
    // MARK: - TableView Delegate and Data Source Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CartsCell = tableView.dequeueReusableCellWithIdentifier("CartCell",forIndexPath:indexPath) as! CartsCell
        cell.configureCartsTableViewCell()
        cell.setupCartsCellContent()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    // MARK: - Setup Bottom CheckOut View Methods
    func setupCheckOutViewDataContent(){
        self.objCheckOutView = CheckOutView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.size.height - 120, self.view.frame.size.width, 120),totalAmount: "$500", savedAmount: "$200")
        self.view.addSubview(self.objCheckOutView)
    }
    
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        // This function use for set layout of components.
        self.setupTopSegmentedControlOnView()
        self.setupCartsTopViewDataContent()
        self.tblCartsView?.frame = CGRectMake(self.tblCartsView!.frame.origin.x, self.tblCartsView!.frame.origin.y ,self.tblCartsView!.frame.size.width , self.view.frame.size.height - 310 )
        if isiPhone5 || isiPhone4s {
            self.lblCurrentStore.font = UIFont.defaultFontOfSize(12.0)
            self.lblCurrentDate.font = UIFont.defaultFontOfSize(12.0)
        }
    }
    
   override func assignDataToComponents(){
        // This function use for assign data to components.
    }
    
}