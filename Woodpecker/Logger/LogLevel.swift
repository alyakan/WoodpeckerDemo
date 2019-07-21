//
//  LogLevel.swift
//  Woodpecker
//
//  Created by Aly Yakan on 7/21/19.
//  Copyright © 2019 Aly. All rights reserved.
//

import Foundation
import CoreData

enum LogLevel: String {
    case e = "[‼️]" // error
    case i = "[ℹ️]" // info
    case d = "[💬]" // debug
    case v = "[🔬]" // verbose
    case w = "[⚠️]" // warning
    case s = "[🔥]" // severe
}

class Log: ObjectConvertible {
    private(set) var identifier: String?
    let level: LogLevel
    let message: String
    
    init(identifier: String, level: LogLevel, message: String) {
        self.level = level
        self.identifier = identifier
        self.message = message
    }
}

@objc(LogMO)
public class LogMO: NSManagedObject, ManagedObjectConvertible {
    typealias T = Log
    
    @NSManaged public var message: String?
    @NSManaged public var level: String?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LogMO> {
        return NSFetchRequest<LogMO>(entityName: "LogMO")
    }
    
    func from(object: Log) {
        message = object.message
        level = object.level.rawValue
    }
    
    func toObject() -> Log {
        let logLevel = LogLevel(rawValue: level ?? LogLevel.d.rawValue) ?? .d
        return Log(identifier: "", level: logLevel, message: message ?? "")
    }
}
