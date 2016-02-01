//
//  ScanProductCell.swift
//  Qist
//
//  Created by GrepRuby on 29/01/16.
//  Copyright © 2016 GrepRuby3. All rights reserved.
//

import UIKit

protocol ScanProductCellDelegates {
    func addProductToCartsTapped(Indexpath : NSIndexPath)
    func addProductToWishListTapped(Indexpath : NSIndexPath)
}

class ScanProductCell: UITableViewCell {
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var lblYouPay: UILabel!
    @IBOutlet var lblYouSave: UILabel!
    @IBOutlet var lblMRP: UILabel!
    @IBOutlet var btnAddWishList: UIButton!
    @IBOutlet var btnAddCart: UIButton!
    @IBOutlet var productImgView: UIImageView!
    
    var cellIndexPath: NSIndexPath!
    
    var productDelegates: ScanProductCellDelegates!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupSpecialsCellContent(dictData : NSDictionary, indexPath : NSIndexPath){
        cellIndexPath = indexPath
        lblTitle.text = dictData["name"] as? String
        lblSubTitle.text = dictData["qr_message"] as? String
        lblYouPay.text = dictData["qist_price"] as? String
        lblMRP.text = dictData["original_price"] as? String
    }
    
    @IBAction func addToWishlistTapped(sender: UIButton){
        self.productDelegates?.addProductToWishListTapped(cellIndexPath)
    }
    
    @IBAction func addToCartsTapped(sender: UIButton){
        self.productDelegates?.addProductToCartsTapped(cellIndexPath)
    }


}
