//
//  RecordSoundsViewControllerTest.swift
//  Pitch Perfect
//
//  Created by Carlos Macasaet on 21/6/15.
//  Copyright © 2015 Carlos Macasaet. All rights reserved.
//

import AVFoundation
import XCTest

@testable import Pitch_Perfect

class RecordSoundsViewControllerTest: XCTestCase {

    class FakeSession : AVAudioSession
    {
        var active:Bool = false
        override func setActive(active: Bool) throws {
            self.active = active
        }
    }
    class FakeRecorder : AVAudioRecorder
    {
        var preparedToRecord = false
        var _recording = false

        override func prepareToRecord() -> Bool
        {
            preparedToRecord = true
            return true
        }
        override func record() -> Bool
        {
            _recording = true
            return true
        }
        override var recording:Bool
        {
            get {
                return _recording
            }
            set (newValue){
            }
        }
    }

    var session:FakeSession?
    var recorder:FakeRecorder?
    var audio:RecordedAudio?

    var controller:RecordSoundsViewController!

    var sender:UIButton?
    var event:UIEvent?

    override func setUp() {
        super.setUp()

        session = FakeSession()
        recorder = FakeRecorder()
        controller = RecordSoundsViewController()
        controller.session = session!
        controller.recorder = recorder!
        controller.recordButton = UIButton()
        controller.stopButton = UIButton()
        controller.statusLabel = UILabel()

        sender = UIButton()
        event = UIEvent()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRecord() throws
    {
        // given

        // when
        try controller.record( sender!, forEvent: event! )

        // then
        assert( recorder!.preparedToRecord )
        assert( recorder!.recording )
    }

    func testStop() throws
    {
        // given

        // when
        try controller.stop( sender!, forEvent: event! )

        // then
        assert( session!.active )
    }

}