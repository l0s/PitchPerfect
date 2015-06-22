//
//  PlaySoundsViewControllerTest.swift
//  Pitch Perfect
//
//  Created by Carlos Macasaet on 12/4/15.
//  Copyright (c) 2015 Carlos Macasaet. All rights reserved.
//

import Foundation
import AVFoundation

import XCTest

@testable import Pitch_Perfect

class PlaySoundsViewControllerTest : XCTestCase
{

    lazy var sender = UIButton()
    lazy var event = UIEvent()

    var controller:PlaySoundsViewController!

    override func setUp() {
        super.setUp()

        class FakeNode : AVAudioPlayerNode
        {
            override func scheduleFile( file: AVAudioFile, atTime when: AVAudioTime?, completionHandler: AVAudioNodeCompletionHandler? )
            {
            }
        }
        class FakeFile : AVAudioFile
        {
        }

        controller = PlaySoundsViewController()
        controller.node = FakeNode()
        controller.file = FakeFile()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testPlaybackLikeDarthVader() throws
    {
        // given

        // when
        try controller.playbackLikeDarthVader( sender, forEvent: event )
        
        // then
        assert( controller.effect.pitch < -500 )
    }

    func testPlaybackQuickly() throws
    {
        // given

        // when
        try controller.playbackQuickly( sender, forEvent: event )
        
        // then
        assert( controller.effect.rate > 1.0 )
    }

    func testStopStopsEngine()
    {
        // given
        class FakeEngine : AVAudioEngine
        {
            var engineStopped = false
            override func stop()
            {
                engineStopped = true
            }
        }
        class FakeNode : AVAudioPlayerNode
        {
            var nodeStopped = false
            override func stop()
            {
                nodeStopped = true
            }
        }
        let engine = FakeEngine()
        let node = FakeNode()
        controller.engine = engine
        controller.node = node

        // when
        controller.stop()

        // then
        assert( engine.engineStopped )
        assert( node.nodeStopped )
    }

}