//
//  ViewController.swift
//  BullsEye
//
//  Created by Srikkanth Govindaraajan on 12/25/18.
//  Copyright © 2018 Srikkanth Govindaraajan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gifImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gifImage.loadGif(name: "bullseyegif")
    }
}
