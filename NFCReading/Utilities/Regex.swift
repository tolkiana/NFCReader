//
//  Regex.swift
//  NFCReading
//
//  Created by Nelida Velazquez on 2/18/18.
//  Copyright © 2018 Detroit Labs LLC. All rights reserved.
//
import Foundation

class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        self.internalExpression = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression.matches(in: input,
                                                      options: [],
                                                      range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
}
