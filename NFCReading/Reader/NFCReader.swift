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
    
    func readerSession(_ session: NFCNDEFReaderSession,
                       didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession,
                       didDetectNDEFs messages: [NFCNDEFMessage]) {
        let parsedMessages = parse(messages)
        readText(from: parsedMessages)
        readURLs(from: parsedMessages)
    }
    
    // MARK: - Private
    
    private func parse(_ messages: [NFCNDEFMessage]) -> [NFCMessage] {
        guard let payloads = messages.first?.records else {
            return []
        }
        return payloads.map {
            NFCMessage(payload: $0)
        }
    }
    
    private func readText(from nfcMessages: [NFCMessage]) {
        let stringMessages = nfcMessages
            .filter{ $0.type == .text }
            .flatMap{ $0.value }.map(String.init)
        finishedReadingMessages?(stringMessages)
    }
    
    private func readURLs(from nfcMessages: [NFCMessage]) {
        let stringUrl = nfcMessages
            .filter { $0.type == .url }
            .flatMap{ $0.value }
            .first.map(String.init)
        if let url = URL(string: stringUrl ?? "") {
            finishedReadingURL?(url)
        }
    }
}

