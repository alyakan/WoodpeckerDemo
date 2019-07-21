//
//  LogLevel.swift
//  Woodpecker
//
//  Created by Aly Yakan on 7/21/19.
//  Copyright © 2019 Aly. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

enum LogLevel: String {
    case e = "[‼️]" // error
    case i = "[ℹ️]" // info
    case d = "[💬]" // debug
    case v = "[🔬]" // verbose
    case w = "[⚠️]" // warning
    case s = "[🔥]" // severe
}

class Log: ObjectConvertible, Identifiable {
    var id: Int
    private(set) var modelIdentifier: String?
    let level: LogLevel
    let message: String
    
    init(id: Int, modelIdentifier: String, level: LogLevel, message: String) {
        self.id = id
        self.level = level
        self.modelIdentifier = modelIdentifier
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
        return Log(id: Int.random(in: 0 ..< 1000), modelIdentifier: "", level: logLevel, message: message ?? "")
    }
}
