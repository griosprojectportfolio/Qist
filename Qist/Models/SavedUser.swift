//
//  SavedUser.swift
//  Qist
//
//  Created by GrepRuby3 on 16/10/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import CoreData

class SavedUser: NSManagedObject {

    @NSManaged var user_name: String
    @NSManaged var password: String

    class func findOrCreateByIDInContext(anID : String , localContext : NSManagedObjectContext) -> SavedUser {
        
        if let objSavedUser : SavedUser = SavedUser.MR_findFirstByAttribute("user_name", withValue: anID, inContext: localContext) {
            return objSavedUser
        }else{
            let objSavedUser : SavedUser = SavedUser.MR_createEntityInContext(localContext)
            return objSavedUser
        }
    }
    
    class func entityFromArrayInContext(aArray : NSArray , localContext : NSManagedObjectContext){
        for aDictionary in aArray {
            SavedUser.entityFromDictionaryInContext(aDictionary as! NSDictionary, localContext: localContext)
        }
    }
    
    class func entityFromDictionaryInContext(aDictionary : NSDictionary, localContext : NSManagedObjectContext){
        
        if let user_name : String = aDictionary["user_name"] as? String {
            
            let objSavedUser : SavedUser = SavedUser.findOrCreateByIDInContext( user_name , localContext: localContext)
            
            objSavedUser.user_name = user_name
            
            if let password : String = aDictionary["password"] as? String {
                objSavedUser.password = password
            }
            
        }
        
    }
}
