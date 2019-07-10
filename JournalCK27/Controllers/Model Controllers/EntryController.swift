//
//  EntryController.swift
//  JournalCK27
//
//  Created by RYAN GREENBURG on 7/9/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    static let shared = EntryController()
    
    let entriesWereUpdatedNotification = Notification.Name("entriesWereUpdated")
    
    var entries: [Entry] = [] {
        didSet {
            NotificationCenter.default.post(name: entriesWereUpdatedNotification, object: nil)
        }
    }
    
    // MARK: - CRUD
    // Create
    func createEntryWith(title: String, body: String) {
        let newEntry = Entry(title: title, body: body)
        let record = CKRecord(entry: newEntry)
        let database = CloudKitController.shared.privateDB
        
        CloudKitController.shared.save(record: record, database: database) { (success) in
            if success {
                self.entries.append(newEntry)
            }
        }
    }
    
    // Read
    func fetchEntries(completion: @escaping (Bool) -> Void) {
        let type = EntryConstants.typeKey
        let database = CloudKitController.shared.privateDB
        CloudKitController.shared.fetchRecordsOf(type: type, database: database) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(false)
            }
            
            guard let records = records else { return }
            let entries = records.compactMap( {Entry(record: $0)} )
            self.entries = entries
            completion(true)
        }
    }
    
    // Update
    func update(entry: Entry, withTitle title: String, body: String) {
        entry.title = title
        entry.body = body
        
        let recordToSave = CKRecord(entry: entry)
        let database = CloudKitController.shared.privateDB
        
        CloudKitController.shared.update(record: recordToSave, database: database) { (success) in
            if success {
                print("Updated entry successfully")
            }
        }
    }
    
    // Delete
    func delete(entry: Entry, completion: @escaping (Bool) -> Void) {
        guard let index = entries.firstIndex(of: entry) else { return }
        entries.remove(at: index)
        
        let database = CloudKitController.shared.privateDB
        
        CloudKitController.shared.delete(recordID: entry.recordID, database: database) { (success) in
            completion(success ? true : false)
        }
    }
}
