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

    class FakeEngine : AVAudioEngine
    {
        var engineStopped = false
        override func stop()
        {
            engineStopped = true
        }
        override func prepare() {
        }
        override func start() throws {
        }
    }
    class FakeNode : AVAudioPlayerNode
    {
        var nodeStopped = false
        var scheduledFile:AVAudioFile?
        var scheduledAtTime:AVAudioTime?
        var scheduledCompletionHandler:AVAudioNodeCompletionHandler?

        override func stop()
        {
            nodeStopped = true
        }
        override func scheduleFile( file: AVAudioFile, atTime when: AVAudioTime?, completionHandler: AVAudioNodeCompletionHandler? )
        {
            scheduledFile = file
            scheduledAtTime = when
            scheduledCompletionHandler = completionHandler
        }
        override func play()
        {
            nodeStopped = false
        }
    }
    class FakeFile : AVAudioFile
    {
    }

    var engine:FakeEngine?
    var node:FakeNode?
    var file:FakeFile?

    var sender:UIButton?
    var event:UIEvent?

    var controller:PlaySoundsViewController!

    override func setUp() {
        super.setUp()

        engine = FakeEngine()
        node = FakeNode()
        file = FakeFile()

        controller = PlaySoundsViewController()
        controller.engine = engine!
        controller.node = node!
        controller.file = file!

        sender = UIButton()
        event = UIEvent()
    }

    override func tearDown()
    {
        super.tearDown()
    }

    func testPlaybackLikeChipmunk() throws
    {
        // given

        // when
        try controller.playbackLikeChipmunk( sender!, forEvent: event! )

        // then
        assert( controller.effect.pitch > 500 )
        assert( node!.scheduledFile == file )
        assert( !node!.nodeStopped )
    }

    func testPlaybackLikeDarthVader() throws
    {
        // given

        // when
        try controller.playbackLikeDarthVader( sender!, forEvent: event! )

        // then
        assert( controller.effect.pitch < -500 )
        assert( node!.scheduledFile == file! )
        assert( !node!.nodeStopped )
    }

    func testPlaybackSlowly() throws
    {
        // given

        // when
        try controller.playbackSlowly( sender!, forEvent: event! )

        // then
        assert( controller.effect.rate < 1.0 )
        assert( node!.scheduledFile == file )
        assert( !node!.nodeStopped )
    }

    func testPlaybackQuickly() throws
    {
        // given

        // when
        try controller.playbackQuickly( sender!, forEvent: event! )

        // then
        assert( controller.effect.rate > 1.0 )
        assert( node!.scheduledFile == file )
        assert( !node!.nodeStopped )
    }

    func testStopStopsEngine()
    {
        // given

        // when
        controller.stop()

        // then
        assert( engine!.engineStopped )
        assert( node!.nodeStopped )
    }

}