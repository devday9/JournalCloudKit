//
//  Entry.swift
//  JournalCK
//
//  Created by Deven Day on 10/5/20.
//

import Foundation
import CloudKit


struct EntryContstants {
    static let titleKey = "title"
    static let bodyKey = "body"
    static let timeStampKey = "timeStamp"
    static let recordTypeKey = "Entry"
}

class Entry {
    
    let title: String
    let body: String
    let timeStamp: Date
    let ckRecordID: CKRecord.ID
    
    init(title: String, body: String, timeStamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timeStamp = timeStamp
        self.ckRecordID = ckRecordID
    }
}//END OF CLASS

//MARK: - Extension

extension CKRecord{
  convenience init(entry: Entry){
    self.init(recordType: EntryContstants.recordTypeKey, recordID: entry.ckRecordID)
    self.setValue(entry.title, forKey: EntryContstants.titleKey)
    self.setValue(entry.body, forKey: EntryContstants.bodyKey)
    self.setValue(entry.timeStamp, forKey: EntryContstants.timeStampKey)
  }
}

extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryContstants.titleKey] as? String,
              let body = ckRecord[EntryContstants.bodyKey] as? String,
              let timeStamp = ckRecord[EntryContstants.timeStampKey] as? Date else {return nil}
        
        self.init(title: title, body: body, timeStamp: timeStamp)
    }
}//END OF EXTENSION
