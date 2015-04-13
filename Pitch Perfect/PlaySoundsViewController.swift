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

    lazy var mainBundle:NSBundle! = {
        return NSBundle.mainBundle()
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
    lazy var engine:AVAudioEngine! = {
        let retval = AVAudioEngine()
        retval.attachNode( self.node )
        retval.attachNode( self.effect )
        retval.connect( self.node, to: self.effect, format: nil )
        retval.connect( self.effect, to: retval.outputNode, format: nil )
        return retval
    }()

    override public func viewWillAppear(animated: Bool) {
        let session = AVAudioSession.sharedInstance()
        var error:NSError?
        let category:String! = AVAudioSessionCategoryPlayAndRecord
        let options:AVAudioSessionCategoryOptions = .DefaultToSpeaker
        let categorySet = session.setCategory(category, withOptions: options, error: &error)
        assert( error == nil, "Error setting audio session category: \(error?.localizedDescription)" )
        assert( categorySet, "Unable to set audio session category." )
    }

    override public func viewWillDisappear( animated: Bool ) {
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