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
    lazy var player:AVAudioPlayer! = {
        var error:NSError?
        let player =
            AVAudioPlayer( contentsOfURL: self.audio.path, error: &error )
        player.enableRate = true
        assert( error == nil )
        return player
    }()
    lazy var engine:AVAudioEngine! = {
        return AVAudioEngine()
    }()
    var file:AVAudioFile!

    override func viewDidLoad() {
        file = AVAudioFile( forReading: audio.path, error: nil )
        println( "-- will play: \(file)" )
    }

    override func viewWillDisappear( animated: Bool ) {
        player.stop()
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
        player.stop()
        engine.stop()
        engine.reset()

        println( "-- playing like a chipmunk" )
        let node = AVAudioPlayerNode()

        let effect = AVAudioUnitTimePitch()
        effect.pitch = 1000

        engine.attachNode( node )
        engine.attachNode( effect )

        println( "-- connecting pipes" )
        engine.connect( node, to: effect, format: nil )
        engine.connect( effect, to: engine.outputNode, format: nil )

        println( "-- preparation" )
        node.scheduleFile( file, atTime: nil, completionHandler: nil )

        engine.prepare()
        var engineError:NSError?
        let engineStarted = engine.startAndReturnError( &engineError )
        assert( engineError == nil )
        assert( engineStarted )

        println( "-- playback" )
        node.play()
    }

    @IBAction func stop( sender: UIButton, forEvent event: UIEvent )
    {
        player.stop()
        player.currentTime = 0
    }

    func playback( rate:Float, pitch:Float )
    {
        player.stop()
        player.rate = rate
        
        let initiated = player.play()
        assert( initiated, "playback not initiated" )
    }

}