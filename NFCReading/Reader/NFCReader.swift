//
//  NFCReader.swift
//  NFCReading
//
//  Created by Nelida Velazquez on 1/14/18.
//  Copyright © 2018 Detroit Labs LLC. All rights reserved.
//

import UIKit
import CoreNFC

@available(iOS 11.0, *)
class NFCReader: NSObject, NFCNDEFReaderSessionDelegate {
    
    var readedMessages: (([String]) -> ())?
    
    func beginSession() {
        let session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
        session.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        let payloads = messages[0].records
        let stringMessages = payloads.flatMap {
            String.init(data: $0.payload.advanced(by: 3), encoding: .utf8)
        }
        self.readedMessages?(stringMessages)
    }
}

