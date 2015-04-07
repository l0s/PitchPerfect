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
    var playbackError:NSError?
    lazy var mainBundle:NSBundle = {
        return NSBundle.mainBundle()
    }()
    lazy var player:AVAudioPlayer = {
        var error:NSError?
        let player =
            AVAudioPlayer( contentsOfURL: self.audio.path, error: &self.playbackError )
        player.enableRate = true
        return player
    }()

    override func viewWillDisappear( animated: Bool ) {
        player.stop()
    }

    @IBAction func playbackSlowly( sender: UIButton, forEvent event: UIEvent )
    {
        playback( 0.5 )
    }

    @IBAction func playbackQuickly( sender: UIButton, forEvent event: UIEvent )
    {
        playback( 2.0 )
    }

    @IBAction func playbackLikeChipmunk(sender: UIButton, forEvent event: UIEvent) {
    }

    @IBAction func stop( sender: UIButton, forEvent event: UIEvent )
    {
        player.stop()
        player.currentTime = 0
    }

    func playback( rate:Float )
    {
        player.stop()
        player.rate = rate
        let initiated = player.play()
        assert( initiated, "playback not initiated" )
        if let error = playbackError
        {
            assert( false, "error occurred: \(error.description)" )
        }
    }

}