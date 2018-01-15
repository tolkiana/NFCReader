//
//  ViewController.swift
//  NFCReading
//
//  Created by Nelida Velazquez on 9/16/17.
//  Copyright © 2017 Detroit Labs LLC. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class ViewController: UIViewController {
    var nfcReader = NFCReader()
    
    @IBOutlet var contentLabel: UILabel!

    @IBAction func scan(_ sender: UIButton) {
        nfcReader.beginSession()
        nfcReader.readedMessages = { messages in
            self.contentLabel.text = messages.joined(separator: " ")
        }
    }
}
