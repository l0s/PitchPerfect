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
        return AVAudioFile( forReading: self.audio.path, error: nil )
    }()

    override func viewWillDisappear( animated: Bool ) {
        engine.stop()
    }

    @IBAction func playbackSlowly( sender: UIButton, forEvent event: UIEvent )
    {
        playback( 0.5, pitch:1.0 )
    }

    @IBAction func playbackQuickly( sender: UIButton, forEvent event: UIEvent )
    {
        playback( 2.0, pitch:1.0 )
    }

    @IBAction func playbackLikeChipmunk( sender: UIButton, forEvent event: UIEvent ) {
        playback( 1.0, pitch: 1000 )
    }

    @IBAction func stop( sender: UIButton, forEvent event: UIEvent )
    {
        engine.stop()
    }

    func playback( rate:Float, pitch:Float )
    {
        engine.stop()
        engine.reset()

        let node = AVAudioPlayerNode()
        let effect = AVAudioUnitTimePitch()
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
        assert( engineError == nil )
        assert( engineStarted )

        node.play()
    }

}