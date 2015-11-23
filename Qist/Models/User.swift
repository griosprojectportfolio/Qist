//
//  User.swift
//  Qist
//
//  Created by GrepRuby3 on 21/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var email_id: String
    @NSManaged var first_name: String
    @NSManaged var last_name: String
    @NSManaged var user_id: String
    @NSManaged var birth_date: String
    @NSManaged var gender: String

    
    class func findOrCreateByIDInContext(anID : String , localContext : NSManagedObjectContext) -> User {
        
        if let objUser : User = User.MR_findFirstByAttribute("user_id", withValue: anID, inContext: localContext) {
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
        
        if let user_id : String = aDictionary["id"] as? String {
        
            let objUser : User = User.findOrCreateByIDInContext( user_id , localContext: localContext)
            
            objUser.user_id = user_id
            
            if let first_name : String = aDictionary["first_name"] as? String {
                objUser.first_name = first_name
            }
            
            if let last_name : String = aDictionary["last_name"] as? String {
                objUser.last_name = last_name
            }
            
            if let email_id : String = aDictionary["email"] as? String {
                objUser.email_id = email_id
            }
            
            if let birth_date : String = aDictionary["birthday"] as? String {
                objUser.birth_date = birth_date
            }
            
            if let gender : String = aDictionary["gender"] as? String {
                objUser.gender = gender
            }
            
        }
        
    }
    
}
