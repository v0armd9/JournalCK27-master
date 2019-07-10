//
//  UserController.swift
//  JournalCK27
//
//  Created by Darin Marcus Armstrong on 7/10/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    //Properties
    static let shared = UserController()
    
    //Source of Truth
    var currentUser: User?
    
    // MARK: - CRUD
    
    //Create
    func createUserWith(username: String, email: String, completion: @escaping (User?) -> Void) {
        
        //Unwrap the optional CKReference or complete nil
        CloudKitController.shared.fetchAppleUserReference { (reference) in
            guard let appleUserReference = reference else {completion(nil); return}
            let newUser = User(username: username, email: email, appleUserReference: appleUserReference)
            let userRecord = CKRecord(user: newUser)
            let database = CloudKitController.shared.privateDB
            
            CloudKitController.shared.save(record: userRecord, database: database) { (record) in
                guard let record = record,
                    let user = User(record: record)
                    else {completion(nil); return}
                
                self.currentUser = user
            }
        }
    }
    
    //Read
    func fetchUser(completion: @escaping(Bool) -> Void) {
        
        //Unwrap the optional CKReference or complete nil
        CloudKitController.shared.fetchAppleUserReference { (reference) in
            guard let appleUserReference = reference else {completion(false); return}
            
            let predicate = NSPredicate(format: "appleUserReference == %@", appleUserReference)
            let database = CloudKitController.shared.privateDB
            CloudKitController.shared.fetchSingleRecord(ofType: Constants.typeKey, withPredicate: predicate, database: database) { (records) in
                guard let records = records,
                    let record = records.first
                    else {completion(false); return}
                
                self.currentUser = User(record: record)
                completion(true)
            }
        }
    }
}
