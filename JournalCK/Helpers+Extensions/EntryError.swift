//
//  EntryError.swift
//  JournalCK
//
//  Created by Deven Day on 10/5/20.
//

import Foundation

enum EntryError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
}
