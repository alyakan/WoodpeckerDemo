//
//  String+SourceFileName.swift
//  Woodpecker
//
//  Created by Aly Yakan on 7/21/19.
//  Copyright © 2019 Aly. All rights reserved.
//

import Foundation

extension String {
    func sourceFileName() -> String {
        let components = self.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
