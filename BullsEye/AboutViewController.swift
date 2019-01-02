//
//  AboutViewController.swift
//  BullsEye
//
//  Created by Srikkanth Govindaraajan on 11/20/18.
//  Copyright © 2018 Srikkanth Govindaraajan. All rights reserved.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let htmlPath = Bundle.main.path(forResource: "BullsEye", ofType: "html") {
            let url = URL(fileURLWithPath: htmlPath)
            let request = URLRequest(url: url)
            print("trying to load")
            webView.load(request)
            print("loaded!!")
        }
    }

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}
