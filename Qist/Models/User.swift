//
//  User.swift
//  Qist
//
//  Created by GrepRuby3 on 05/01/16.
//  Copyright © 2016 GrepRuby3. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var email: String?
    @NSManaged var first_name: String?
    @NSManaged var last_name: String?
    @NSManaged var id: NSNumber?
    @NSManaged var facebook_id: NSNumber?
    @NSManaged var address_1: String?
    @NSManaged var address_2: String?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var state: String?
    @NSManaged var googleplus_id: NSNumber?
    @NSManaged var twitter_id: NSNumber?
    @NSManaged var image: String?
    @NSManaged var device_token: String?
    @NSManaged var contact_no: String?

    
    class func findOrCreateByIDInContext(anID : NSNumber , localContext : NSManagedObjectContext) -> User {
        
        if let objUser : User = User.MR_findFirstByAttribute("id", withValue: anID, inContext: localContext) {
            return objUser
        }else{
            let objUser : User = User.MR_createEntityInContext(localContext)
            return objUser
        }
    }
    
    class func entityFromArrayInContext(aArray : NSArray , localContext : NSManagedObjectContext){
        for aDictionary in aArray {
            User.entityFromDictionaryInContext(aDictionary as! NSDictionary, localContext: localContext)
        }
    }
    
    class func entityFromDictionaryInContext(aDictionary : NSDictionary, localContext : NSManagedObjectContext){
        
        if let user_id : Int64 = Int64(aDictionary["id"] as! String) {
            
            let objUser : User = User.findOrCreateByIDInContext( NSNumber(longLong: user_id) , localContext: localContext)
            
            objUser.id = NSNumber(longLong: user_id)
            
            if let email : String = aDictionary["email"] as? String {
                objUser.email = email
            }

            if let first_name : String = aDictionary["firstname"] as? String {
                objUser.first_name = first_name
            }
            
            if let last_name : String = aDictionary["lastname"] as? String {
                objUser.last_name = last_name
            }
            
            if let facebook_id : String = aDictionary["facebookid"] as? String {
                objUser.facebook_id = NSNumber(longLong: Int64(facebook_id)!)
            }
            
            if let address_1 : String = aDictionary["address_1"] as? String {
                objUser.address_1 = address_1
            }
            
            if let address_2 : String = aDictionary["address_2"] as? String {
                objUser.address_2 = address_2
            }
            
            if let city : String = aDictionary["city"] as? String {
                objUser.city = city
            }
            
            if let country : String = aDictionary["country"] as? String {
                objUser.country = country
            }
            
            if let state : String = aDictionary["state"] as? String {
                objUser.state = state
            }
            
            if let googleplus_id : String = aDictionary["googleplusid"] as? String {
                objUser.googleplus_id = NSNumber(longLong: Int64(googleplus_id)!)
            }
            
            if let twitter_id : String = aDictionary["twitterid"] as? String {
                objUser.twitter_id = NSNumber(longLong:Int64(twitter_id)!)
            }
            
            if let image : String = aDictionary["image"] as? String {
                objUser.image = image
            }
            
            if let device_token : String = aDictionary["device_token"] as? String {
                objUser.device_token = device_token
            }
            
            if let contact_no : String = aDictionary["contact_no"] as? String {
                objUser.contact_no = contact_no
            }
            print("final Store========\(objUser)")
        }
        
    }
    
}
