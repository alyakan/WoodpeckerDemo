//
//  LogStore.swift
//  Woodpecker
//
//  Created by Aly Yakan on 7/21/19.
//  Copyright © 2019 Aly. All rights reserved.
//

import Foundation
import CoreData

class LogStore {
    private let coredataStore: CoreDataStore
    
    private lazy var writeContext: NSManagedObjectContext = {
        return self.coredataStore.newBackgroundContext()
    }()
    
    private lazy var viewContext: NSManagedObjectContext = {
        return self.coredataStore.viewContext
    }()
    
    init(coredataStore: CoreDataStore = CoreDataStore.shared) {
        self.coredataStore = coredataStore
    }
    
    func insert(_ log: Log) {
        LogMO.insert(log, with: writeContext)
    }
    
    func update(_ log: Log) {
        LogMO.update(log, with: writeContext)
    }
    
    func delete(_ log: Log) {
        LogMO.delete(log, with: writeContext)
    }
    
    func fetchAll() -> [Log] {
        return LogMO.fetchAll(from: viewContext)
    }
}
