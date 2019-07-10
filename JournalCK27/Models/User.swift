//
//  User.swift
//  JournalCK27
//
//  Created by Darin Marcus Armstrong on 7/10/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

struct Constants {
    static let typeKey = "User"
    fileprivate static let usernameKey = "Username"
    fileprivate static let emailKey = "Email"
    fileprivate static let appleUserReferenceKey = "appleUserReference"
}

class User {
    //Class Properties
    var username: String
    var email: String
    //iCloud class properties
    let recordID: CKRecord.ID
    let appleUserReference: CKRecord.Reference
    
    ///Initializes a new User object
    init(username: String, email: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        self.username = username
        self.email = email
        self.recordID = recordID
        self.appleUserReference = appleUserReference
    }
}

extension User {
    ///Initializes an ecisting User object from a CKRecord
    convenience init?(record: CKRecord) {
        // check against values
        guard let username = record[Constants.usernameKey] as? String,
            let email = record[Constants.emailKey] as? String,
            let appleUserReference = record[Constants.appleUserReferenceKey] as? CKRecord.Reference
            else { return nil }
        
        self.init(username: username, email: email, recordID: record.recordID, appleUserReference: appleUserReference)
        
    }
}

extension CKRecord {
    ///Initializes a CKRecord from an existing User object
    convenience init(user: User) {
        self.init(recordType: Constants.typeKey, recordID: user.recordID)
        
        self.setValue(user.username, forKey: Constants.usernameKey)
        self.setValue(user.email, forKey: Constants.emailKey)
        self.setValue(user.appleUserReference, forKey: Constants.appleUserReferenceKey)
    }
}

