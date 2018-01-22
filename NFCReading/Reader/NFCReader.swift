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
    
    var finishedReadingURL: ((URL) -> ())?
    var finishedReadingMessages: (([String]) -> ())?
    
    func beginSession() {
        let session = NFCNDEFReaderSession(delegate: self,
                                           queue: DispatchQueue.main,
                                           invalidateAfterFirstRead: true)
        session.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        let parsedMessages = parse(messages)
        readMessages(from: parsedMessages)
        readURLs(from: parsedMessages)
    }
    
    // MARK: - Private
    
    private func parse(_ messages: [NFCNDEFMessage]) -> [NFCMessage] {
        guard let payloads = messages.first?.records else {
            return []
        }
        return payloads.map {
            let type = NFCType(rawValue: $0.type.decode())
            switch type {
            case .url:
                return NFCMessage(type: type,
                                  value: $0.payload.decode(skipping: 1))
            default:
                return NFCMessage(type: type,
                                  value: $0.payload.decode(skipping: 3))
            }
        }
    }
    
    private func readMessages(from nfcMessages: [NFCMessage]) {
        let stringMessages = nfcMessages
            .filter{ $0.type == .text }
            .flatMap{ $0.value }
        finishedReadingMessages?(stringMessages)
    }
    
    private func readURLs(from nfcMessages: [NFCMessage]) {
        let stringUrl = nfcMessages
            .filter { $0.type == .url }
            .flatMap{ $0.value }
            .first
        if let url = URL(string: stringUrl ?? "") {
            finishedReadingURL?(url)
        }
    }
}

