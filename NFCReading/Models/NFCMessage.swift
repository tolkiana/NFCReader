//
//  NFCMessage.swift
//  NFCReading
//
//  Created by Nelida Velazquez on 1/14/18.
//  Copyright © 2018 Detroit Labs LLC. All rights reserved.
//

import CoreNFC

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
    var value: String
}

extension NFCMessage {
    @available(iOS 11.0, *)
    init(payload: NFCNDEFPayload) {
        print("raw message: \(payload.payload.decode())")
        let type = NFCType(rawValue: payload.type.decode())
        switch type {
        case .url:
            self.init(type: type,
                      value: payload.payload.decode(skipping: 1))
        default:
            self.init(type: type,
                      value: payload.payload.decode(skipping: 3).decodeEmojis())
        }
    }
}
