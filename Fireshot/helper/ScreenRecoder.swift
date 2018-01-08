//
//  ScreenRecoder.swift
//  Fireshot
//
//  Created by Toan Nguyen Dinh on 1/8/18.
//  Copyright © 2018 Toan Nguyen Dinh. All rights reserved.
//

import Foundation
import AVFoundation

public class ScreenRecorder: NSObject, AVCaptureFileOutputRecordingDelegate {
    
    
    var destinationUrl: NSURL
    var session: AVCaptureSession?
    var movieFileOutput: AVCaptureMovieFileOutput?
    
    public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // implement here
        
    }
    
    
    public var destination: NSURL {
        get {
            return self.destinationUrl
        }
    }
    
    public init(destination: NSURL) {
        self.destinationUrl = destination
        
        self.session = AVCaptureSession()
        self.session?.sessionPreset = AVCaptureSession.Preset.high
        
        let displayId: CGDirectDisplayID = CGDirectDisplayID(CGMainDisplayID())
        
        guard let input: AVCaptureScreenInput = AVCaptureScreenInput(displayID: displayId) else{
            
            self.session = nil
            return
        }
        
       
        
        
        
        if ((self.session?.canAddInput(input)) != nil) {
            self.session?.addInput(input)
        }
        
        self.movieFileOutput = AVCaptureMovieFileOutput()
        
        
        if let _ = self.session?.canAddOutput(self.movieFileOutput!){
            self.session?.addOutput(self.movieFileOutput!)
        }
       
    }
    
    public func start() {
        self.session?.startRunning()
        self.movieFileOutput?.startRecording(to: self.destinationUrl as URL, recordingDelegate: self)
    }
    
    public func stop() {
        self.movieFileOutput?.stopRecording()
    }
    
    public func captureOutput(
        captureOutput: AVCaptureFileOutput!,
        didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!,
        fromConnections connections: [AnyObject]!,
        error: NSError!
        ) {
        self.session?.stopRunning()
        self.session = nil
    }
}
