//
//  ViewController.swift
//  NFCReading
//
//  Created by Nelida Velazquez on 9/16/17.
//  Copyright © 2017 Detroit Labs LLC. All rights reserved.
//

import UIKit
import CoreNFC

@available(iOS 11.0, *)
class ViewController: UIViewController {
    
    var nfcSession: NFCNDEFReaderSession?
    
    @IBOutlet var contentLabel: UILabel!

    @IBAction func scan(_ sender: UIButton) {
        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.begin()
    }
}

@available(iOS 11.0, *)
extension ViewController: NFCNDEFReaderSessionDelegate {

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = ""
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)!
        }
        
        for message in messages {
            for record in message.records {
                print("Record Type Id    \(record.typeNameFormat)")
                print("Record Type       \(record.type)")
                print("Record Payload    \(record.payload)")
                print("Record Identifier \(record.identifier)")
            }
        }
        
        DispatchQueue.main.async {
            self.contentLabel.text = result
        }
    }
}

