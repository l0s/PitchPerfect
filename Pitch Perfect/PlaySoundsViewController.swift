//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Carlos Macasaet on 1/4/15.
//  Copyright (c) 2015 Carlos Macasaet. All rights reserved.
//

import UIKit
import AVFoundation

public class PlaySoundsViewController: UIViewController {

    var audio:RecordedAudio!
    var file:AVAudioFile!

    lazy var mainBundle:NSBundle! = NSBundle.mainBundle()
    lazy var node:AVAudioPlayerNode = AVAudioPlayerNode()
    lazy var effect:AVAudioUnitTimePitch = AVAudioUnitTimePitch()
    lazy var engine:AVAudioEngine! = {
        let retval = AVAudioEngine()
        retval.attachNode( self.node )
        retval.attachNode( self.effect )
        retval.connect( self.node, to: self.effect, format: nil )
        retval.connect( self.effect, to: retval.outputNode, format: nil )
        return retval
    }()
    lazy var session = AVAudioSession.sharedInstance()

    override public func viewDidLoad() {
        super.viewDidLoad()

        do
        {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
        }
        catch let error as NSError
        {
            print( "Unable to route audio to loudspeaker: \(error.localizedDescription)" )
        }
    }

    override public func viewWillDisappear( animated: Bool ) {
        engine.stop()

        super.viewWillDisappear( animated )
    }

    @IBAction func playbackSlowly( sender: UIButton, forEvent event: UIEvent ) throws
    {
        try playback( 0.5 )
    }

    @IBAction func playbackQuickly( sender: UIButton, forEvent event: UIEvent ) throws
    {
        try playback( 2.0 )
    }

    @IBAction func playbackLikeChipmunk( sender: UIButton, forEvent event: UIEvent ) throws
    {
        try playback( pitch: 1000 )
    }

    @IBAction func playbackLikeDarthVader( sender: UIButton, forEvent event: UIEvent ) throws
    {
        try playback( pitch: -1000 )
    }

    @IBAction func stop()
    {
        engine.stop()
        node.stop()
    }

    func playback( rate:Float = 1.0, pitch:Float = 1.0 ) throws
    {
        stop()
        reset()

        effect.rate = rate
        effect.pitch = pitch

        if( file == nil )
        {
            try file = AVAudioFile( forReading: self.audio.path )
        }
        node.scheduleFile( file, atTime: nil, completionHandler: nil )

        engine.prepare()
        try engine.start()

        node.play()
    }

    func reset()
    {
        engine.reset()
        node.reset()
        effect.reset()
    }

}