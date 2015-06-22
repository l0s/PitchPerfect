//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Carlos Macasaet on 11/3/15.
//  Copyright (c) 2015 Carlos Macasaet. All rights reserved.
//

import UIKit
import AVFoundation

public class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!

    lazy var fileName:String = {
        let scratchDirectory =
            NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true )[ 0 ] as String
        return scratchDirectory + "/pitch-perfect-recording.wav";
    }()
    lazy var session:AVAudioSession = AVAudioSession.sharedInstance()

    var recorder:AVAudioRecorder? // optional because creation can fail

    var audio:RecordedAudio?

    func createRecorder() throws -> AVAudioRecorder
    {
        let retval = try AVAudioRecorder( URL:NSURL( fileURLWithPath:self.fileName ), settings: Dictionary<String, AnyObject>() )
        retval.delegate = self
        retval.meteringEnabled = true
        return retval
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear( animated )
        stopButton.hidden = true
    }

    @IBAction func record(sender: AnyObject, forEvent event: UIEvent) throws
    {
        statusLabel.hidden = false

        recordButton.enabled = false

        stopButton.hidden = false
        stopButton.enabled = true

        try session.setCategory( AVAudioSessionCategoryPlayAndRecord )

        if( recorder == nil )
        {
            recorder = try createRecorder()
        }
        recorder!.prepareToRecord()
        recorder!.record()
    }

    public func audioRecorderDidFinishRecording( recorder: AVAudioRecorder, successfully flag: Bool ) {
        assert( flag, "recording failed" )

        audio = RecordedAudio()
        audio!.title = recorder.url.lastPathComponent
        audio!.path = recorder.url

        performSegueWithIdentifier( "stopRecording", sender: recorder )
    }

    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if( segue.identifier == "stopRecording" )
        {
            let target = segue.destinationViewController as! PlaySoundsViewController
            target.audio = audio
        }
    }

    @IBAction func stop(sender: AnyObject, forEvent event: UIEvent) throws
    {
        if( recorder != nil )
        {
            recorder!.stop()
            try session.setActive( false )

            stopButton.enabled = false
            statusLabel.hidden = true
            recordButton.enabled = true
        }
    }

}