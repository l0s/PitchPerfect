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
        var stopped = false;

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
        override func stop() {
            stopped = true
        }
    }

    var session:FakeSession?
    var recorder:FakeRecorder?
    var audio:RecordedAudio?
    var recordButton:UIButton?
    var stopButton:UIButton?
    var statusLabel:UILabel?

    var controller:RecordSoundsViewController!

    var sender:UIButton?
    var event:UIEvent?

    override func setUp() {
        super.setUp()

        session = FakeSession()
        recorder = FakeRecorder()
        recordButton = UIButton()
        stopButton = UIButton()
        statusLabel = UILabel()
        controller = RecordSoundsViewController()
        controller.session = session!
        controller.recorder = recorder!
        controller.recordButton = recordButton
        controller.stopButton = stopButton
        controller.statusLabel = statusLabel

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
        XCTAssertTrue( recorder!.preparedToRecord )
        XCTAssertTrue( recorder!.recording )
    }

    func testStop() throws
    {
        // given

        // when
        try controller.stop( sender!, forEvent: event! )

        // then
        XCTAssertTrue( session!.active )
    }

}