//
//  Entry.swift
//  JournalCK27
//
//  Created by RYAN GREENBURG on 7/9/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

class Entry {
    
    var title: String
    var body: String
    let timestamp: Date
    let recordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.recordID = recordID
    }
    
    init?(record: CKRecord) {
        guard let title = record[EntryConstants.titleKey] as? String,
            let body = record[EntryConstants.bodyKey] as? String,
            let timestamp = record[EntryConstants.timestampKey] as? Date
            else { return nil }
        
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.recordID = record.recordID
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.typeKey, recordID: entry.recordID)
        self.setValue(entry.title, forKey: EntryConstants.titleKey)
        self.setValue(entry.body, forKey: EntryConstants.bodyKey)
        self.setValue(entry.timestamp, forKey: EntryConstants.timestampKey)
    }
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

struct EntryConstants {
    static let typeKey = "Entry"
    fileprivate static let titleKey = "title"
    fileprivate static let bodyKey = "body"
    fileprivate static let timestampKey = "timestamp"
}
