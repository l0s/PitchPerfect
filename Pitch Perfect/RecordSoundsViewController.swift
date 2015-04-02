//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Carlos Macasaet on 11/3/15.
//  Copyright (c) 2015 Carlos Macasaet. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!

    lazy var fileName:String = {
        let scratchDirectory =
            NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true )[ 0 ] as String
        return scratchDirectory + "/pitch-perfect-recording.wav";
    }()
    lazy var session:AVAudioSession = {
        return AVAudioSession.sharedInstance()
    }()
    lazy var recorder:AVAudioRecorder = {
        var error:NSError?
        println( "-- saving to: \( self.fileName )" )
        let retval =
            AVAudioRecorder( URL:NSURL( fileURLWithPath:self.fileName ), settings:nil, error:&error )
        retval.meteringEnabled = true
        assert( error == nil, "Error creating audio recorder: \( error!.localizedDescription )" )
        return retval
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(animated: Bool) {
//        NSFileManager.defaultManager().removeItemAtPath(fileName, error:nil )
    }

    @IBAction func record(sender: AnyObject, forEvent event: UIEvent) {
        statusLabel.hidden = false

        recordButton.enabled = false

        stopButton.hidden = false
        stopButton.enabled = true

        var error:NSError?
        session.setCategory( AVAudioSessionCategoryPlayAndRecord, error:&error )
        assert( error == nil, "Error setting audio session category: \( error!.localizedDescription )" )

        recorder.prepareToRecord()
        recorder.record()
    }

    @IBAction func stop(sender: AnyObject, forEvent event: UIEvent) {
        recorder.stop()
        session.setActive( false, error: nil )

        stopButton.enabled = false
        statusLabel.hidden = true
        recordButton.enabled = true
    }

}