//
//  CloudKitController.swift
//  JournalCK27
//
//  Created by RYAN GREENBURG on 7/9/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitController {
    
    static let shared = CloudKitController()
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - CRUD
    // Create
    func save(record: CKRecord, database: CKDatabase, completion: @escaping (Bool) -> Void) {
        // save the record passed in, complete with an optional error
        database.save(record) { (_, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(false)
            }
            print(#function)
            completion(true)
        }
    }
    
    // Read
    func fetchRecordsOf(type: String, database: CKDatabase, completion: @escaping ([CKRecord]?, Error?) -> Void) {
        // Conditions of query, conditions to be return all found values
        let predicate = NSPredicate(value: true)
        // defines the record type we want to find, applies our predicate conditions
        let query = CKQuery(recordType: type, predicate: predicate)
        // Perform query, complete with our optional records and optional error
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil, error)
            }
            if let records = records {
                completion(records, nil)
            }
        }
    }
    
    // Update
    func update(record: CKRecord, database: CKDatabase, completion: @escaping (Bool) -> Void) {
        let operation = CKModifyRecordsOperation()
        operation.recordsToSave = [record]
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.queuePriority = .high
        operation.completionBlock = {
            completion(true)
        }
        database.add(operation)
    }
    
    // Delete
    func delete(recordID: CKRecord.ID, database: CKDatabase, completion: @escaping (Bool) -> Void) {
        database.delete(withRecordID: recordID) { (_, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(false)
            }
            completion(true)
        }
    }
}
