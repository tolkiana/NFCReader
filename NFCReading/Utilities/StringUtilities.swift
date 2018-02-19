//
//  StringUtilities.swift
//  NFCReading
//
//  Created by Nelida Velazquez on 2/18/18.
//  Copyright © 2018 Detroit Labs LLC. All rights reserved.
//

import Foundation

extension String {
    
    func decodeEmojis() -> String {
        return self
            .split(separator: " ")
            .map { String($0).convertToEmojiIfPossible() }
            .joined(separator: " ")
    }
    
    private func convertToEmojiIfPossible() -> String {
        if Regex("^u\\d*$").test(input: self) {
            guard let representation = Int(self.dropFirst()),
                let unicodeScalar = UnicodeScalar(representation) else {
                return self
            }
            return String(unicodeScalar)
        }
        return self
    }
    
}

