//
//  Logger.swift
//  Woodpecker
//
//  Created by Aly Yakan on 7/21/19.
//  Copyright © 2019 Aly. All rights reserved.
//

import UIKit

func print(_ object: Any) {
    // Only allowing in DEBUG mode
    #if DEBUG
    Swift.print(object)
    #endif
}

class Logger {
    // 1. The date formatter
    static var isLoggingEnabled = true
    static let appDelegate = UIApplication.shared.delegate as? AppDelegate
    static let context = appDelegate?.persistentContainer.newBackgroundContext()
    
    class func e( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        funcName: String = #function) {
        log(object, filename: filename, line: line, funcName: funcName, level: .e)
    }
    
    class func i( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        funcName: String = #function) {
        log(object, filename: filename, line: line, funcName: funcName, level: .i)
    }
    
    class func d( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        funcName: String = #function) {
        log(object, filename: filename, line: line, funcName: funcName, level: .d)
    }
    
    class func v( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        funcName: String = #function) {
        log(object, filename: filename, line: line, funcName: funcName, level: .v)
    }
    
    class func w( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        funcName: String = #function) {
        log(object, filename: filename, line: line, funcName: funcName, level: .w)
    }
    
    class func s( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        funcName: String = #function) {
        log(object, filename: filename, line: line, funcName: funcName, level: .s)
    }
    
    class func log( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        funcName: String = #function,
        level: LogLevel = LogLevel.d) {
        if isLoggingEnabled {
            let date = Date().string()
            let message = "[\(date)]\(level.rawValue)[\(filename.sourceFileName()), line \(line)][\(funcName)] -> \(object)"
            print(message)
            
            guard let context = context else {
                return
            }
            
            let log = Log(identifier: "LogMO", level: level, message: message)
            LogMO.insert(log, with: context)
        }
    }
}
