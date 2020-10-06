//
//  EntryController.swift
//  JournalCK
//
//  Created by Deven Day on 10/5/20.
//

import Foundation
import CloudKit

class EntryController {
    
    static let sharedInstance = EntryController()
    
    var entries: [Entry] = []
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //MARK: - CRUD
    
    func createEntry(with title: String, body: String, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        
        let newEntry = Entry(title: title, body: body)
        
        save(entry: newEntry, completion: completion)
    }
    
    func save(entry: Entry, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        
        let entryRecord = CKRecord(entry: entry)
        privateDB.save(entryRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
                return
            }
            
            guard let record = record,
                  let savedEntry = Entry(ckRecord: record)
            else { completion(.failure(.couldNotUnwrap)); return}
            print("New entry saved successfully")
            self.entries.insert(savedEntry, at: 0)
            completion(.success(savedEntry))
        }
    }
    
    func fetchEntriesWith(completion: @escaping (_ results: Result<[Entry]?, EntryError>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryContstants.recordTypeKey, predicate: predicate)
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { completion(.failure(.couldNotUnwrap)); return}
            print("Successfully fetched all Entries")
            
            let entries = records.compactMap({ Entry(ckRecord: $0) })
            self.entries = entries
            completion(.success(entries))
        }
    }
}//END OF CLASS
