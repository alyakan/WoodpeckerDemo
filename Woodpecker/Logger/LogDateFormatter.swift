//
//  LogDateFormatter.swift
//  Woodpecker
//
//  Created by Aly Yakan on 7/21/19.
//  Copyright © 2019 Aly. All rights reserved.
//

import Foundation

class LogDateFormatter {
    static var dateFormat = "dd-MM-yyyy hh:mm:ssSSS"
    static var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
}
