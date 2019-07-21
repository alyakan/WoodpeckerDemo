//
//  Date+LogDateFormatter.swift
//  Woodpecker
//
//  Created by Aly Yakan on 7/21/19.
//  Copyright © 2019 Aly. All rights reserved.
//

import Foundation

extension Date {
    func string() -> String {
        return LogDateFormatter.formatter.string(from: self as Date)
    }
}
