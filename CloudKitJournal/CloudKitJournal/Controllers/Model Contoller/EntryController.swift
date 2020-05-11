//
//  EntryController.swift
//  CloudKitJournal
//
//  Created by Bryce Bradshaw on 5/11/20.
//  Copyright © 2020 Zebadiah Watson. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    // MARK: - Singleton
    static let sharedInstance = EntryController()
    
    // MARK: - Source of Truth
    var entries: [Entry] = []
    
    // MARK: - Properties
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - CRUD
    func createEntryWith(title: String, body: String, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        
        let newEntry = Entry(title: title, body: body)
        saveEntry(entry: newEntry, completion: completion)
    }
    
    func saveEntry(entry: Entry, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        
        let record = CKRecord(entry: entry)
        privateDB.save(record) { (record, error) in
            if let error = error {
                print("Error when trying to save Entry to Database.")
                completion(.failure(.ckError(error)))
            }
            guard let record = record, let savedEntry = Entry(ckRecord: record) else { return completion(.failure(.couldNotUnwrap))}
            self.entries.insert(savedEntry, at: 0)
            completion(.success(savedEntry))
        }
    }
    
    func fetchEntriesWith(completion: @escaping(_ result: Result<[Entry], EntryError>) -> Void) {
        
        let fetchEntriesPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.recordTypeKey, predicate: fetchEntriesPredicate)
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error when trying to Fetch entries.")
                completion(.failure(.ckError(error)))
            }
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            print("Records successfully Fetched.")
            
            let entries = records.compactMap { Entry(ckRecord: $0)}
            self.entries = entries
            completion(.success(entries))
        }
    }
}
