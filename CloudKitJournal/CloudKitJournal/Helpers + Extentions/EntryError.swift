//
//  EntryError.swift
//  CloudKitJournal
//
//  Created by Bryce Bradshaw on 5/11/20.
//  Copyright © 2020 Zebadiah Watson. All rights reserved.
//

import Foundation

enum EntryError: LocalizedError {
    
   case ckError(Error)
   case couldNotUnwrap
}
