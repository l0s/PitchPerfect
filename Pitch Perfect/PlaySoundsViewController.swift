//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Carlos Macasaet on 1/4/15.
//  Copyright (c) 2015 Carlos Macasaet. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audio:RecordedAudio!

    lazy var mainBundle:NSBundle! = {
        return NSBundle.mainBundle()
    }()
    lazy var engine:AVAudioEngine! = {
        return AVAudioEngine()
    }()
    lazy var file:AVAudioFile! = {
        var error:NSError?
        let retval = AVAudioFile( forReading: self.audio.path, error: &error )
        assert( error == nil, "Error referencing recorded file: \(error?.localizedDescription)" )
        return retval
    }()
    lazy var node:AVAudioPlayerNode = {
        return AVAudioPlayerNode()
    }()
    lazy var effect:AVAudioUnitTimePitch = {
        return AVAudioUnitTimePitch()
    }()

    override func viewWillDisappear( animated: Bool ) {
        engine.stop()
    }

    @IBAction func playbackSlowly( sender: UIButton, forEvent event: UIEvent )
    {
        playback( rate:0.5 )
    }

    @IBAction func playbackQuickly( sender: UIButton, forEvent event: UIEvent )
    {
        playback( rate:2.0 )
    }

    @IBAction func playbackLikeChipmunk( sender: UIButton, forEvent event: UIEvent ) {
        playback( pitch: 1000 )
    }

    @IBAction func playbackLikeDarthVader( sender: UIButton, forEvent event: UIEvent ) {
        playback( pitch: -1000 )
    }

    @IBAction func stop()
    {
        engine.stop()
        node.stop()
    }

    func playback( rate:Float = 1.0, pitch:Float = 1.0 )
    {
        stop()
        reset()

        effect.rate = rate
        effect.pitch = pitch

        engine.attachNode( node )
        engine.attachNode( effect )

        engine.connect( node, to: effect, format: nil )
        engine.connect( effect, to: engine.outputNode, format: nil )

        node.scheduleFile( file, atTime: nil, completionHandler: nil )

        engine.prepare()
        var engineError:NSError?
        let engineStarted = engine.startAndReturnError( &engineError )
        assert( engineError == nil, "Error starting audio engine: \(engineError?.localizedDescription)." )
        assert( engineStarted, "Unable to start audio engine." )

        node.play()
    }

    func reset()
    {
        engine.reset()
        node.reset()
        effect.reset()
    }

}