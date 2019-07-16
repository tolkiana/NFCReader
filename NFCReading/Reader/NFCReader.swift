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
class NFCReader: NSObject, NFCNDEFReaderSessionDelegate, NFCTagReaderSessionDelegate {
    var finishedReadingURL: ((URL) -> ())?
    var finishedReadingMessages: (([String]) -> ())?
    
    // MARK: - NFCTagReaderSessionDelegate
    
    @available(iOS 13.0, *)
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("Session is Active!");
    }
    
    @available(iOS 13.0, *)
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    @available(iOS 13.0, *)
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("Detected some tags!");
        print(tags)
    }
    
    
    // MARK: - NFCNDEFReaderSessionDelegate
    
    func beginSession() {
        if #available(iOS 13.0, *) {
            let session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
            session?.begin()
        } else {
            let session = NFCNDEFReaderSession(delegate: self,
                                               queue: DispatchQueue.main,
                                               invalidateAfterFirstRead: true)
            session.begin()
        }
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
    
    @available(iOS 13.0, *)
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            print("Couldn't read tag");
            return;
        }
        session.connect(to: tag) { (error: Error?) in
            tag.readNDEF { (message: NFCNDEFMessage?, error: Error?) in
                let parsedMessages = self.parse(message)
                self.readText(from: parsedMessages)
                self.readURLs(from: parsedMessages)
                session.invalidate()
            }
        }
    }

    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("Session is Active!");
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
    
    private func parse(_ message: NFCNDEFMessage?) -> [NFCMessage] {
        guard let message = message else {
            return []
        }
        return parse([message])
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

