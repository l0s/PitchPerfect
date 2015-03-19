//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Carlos Macasaet on 11/3/15.
//  Copyright (c) 2015 Carlos Macasaet. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func record(sender: AnyObject, forEvent event: UIEvent) {
        statusLabel.hidden = false
        stopButton.enabled = true
    }

    @IBAction func stop(sender: AnyObject, forEvent event: UIEvent) {
        stopButton.enabled = false
        statusLabel.hidden = true
    }
}