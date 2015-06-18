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

    lazy var mainBundle:NSBundle! = NSBundle.mainBundle()
    lazy var file:AVAudioFile! = {
        var error:NSError?
        let retval: AVAudioFile!
        do {
            retval = try AVAudioFile( forReading: self.audio.path)
        } catch var error1 as NSError {
            error = error1
            retval = nil
        } catch {
            fatalError()
        }
        assert( error == nil, "Error referencing recorded file: \(error?.localizedDescription)" )
        return retval
    }()
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

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let session = AVAudioSession.sharedInstance()
        let category:String! = AVAudioSessionCategoryPlayAndRecord
        let options:AVAudioSessionCategoryOptions = .DefaultToSpeaker
        do
        {
            try session.setCategory(category, withOptions: options)
        }
        catch let error as NSError
        {
            print( "Unable to route audio to loudspeaker: \(error.localizedDescription)" )
        }
    }

    override public func viewWillDisappear( animated: Bool ) {
        engine.stop()
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