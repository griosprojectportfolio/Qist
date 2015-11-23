//
//  AboutController.swift
//  Qist
//
//  Created by GrepRuby3 on 06/10/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class AboutController : BaseController {

    
    @IBOutlet var lblAboutUs: UILabel!
    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "ABOUT"
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
        self.lblAboutUs.font = UIFont.defaultFontOfSize(15.0)
        self.lblAboutUs.textColor = UIColor.appCellSubTitleColor()
    }
    
    override func assignDataToComponents(){
        // This function use for assign data to components.
        self.lblAboutUs.text = "Qist (pronounced Kissed) is the loyalty card with a difference. Instead of just gathering your data and accumulating points, Qist gives you what you want most, instant savings and discounts specific to you! In return you share your shopping habits with the retailers you choose, which they will use to market their best deals to you! See our website for full terms and conditions"
    }
    
}