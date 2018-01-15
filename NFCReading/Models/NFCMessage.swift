//
//  NFCMessage.swift
//  NFCReading
//
//  Created by Nelida Velazquez on 1/14/18.
//  Copyright © 2018 Detroit Labs LLC. All rights reserved.
//

import Foundation

enum NFCType: String {
    case text = "T"
    case url = "U"
    
    init(rawValue: String) {
        switch rawValue {
        case "U": self = .url
        default: self = .text
        }
    }
}

struct NFCMessage {
    var type: NFCType
    var value: String?
}
