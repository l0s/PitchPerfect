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

    var playbackError:NSError?
    lazy var mainBundle:NSBundle = {
        return NSBundle.mainBundle()
    }()
    lazy var player:AVAudioPlayer = {
        let path:String! = self.mainBundle.pathForResource( "movie_quote", ofType: "mp3" )
        let url = NSURL( fileURLWithPath: path )
        var error:NSError?
        let player = AVAudioPlayer( contentsOfURL: url, error: &self.playbackError );
        player.volume = 1.0
        return player
    }()

    @IBAction func playbackSlowly( sender: UIButton, forEvent event: UIEvent ) {
        player.prepareToPlay()
        let initiated = player.play()
        assert( initiated, "playback not initiated" )
        if let error = playbackError
        {
            assert( false, "error occurred: \(error.description)" )
        }
    }

}