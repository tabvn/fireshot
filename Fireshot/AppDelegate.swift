//
//  AppDelegate.swift
//  Fireshot
//
//  Created by Toan Nguyen Dinh on 1/4/18.
//  Copyright © 2018 Toan Nguyen Dinh. All rights reserved.
//

import Cocoa
import FirebaseCore

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    let statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var fs: Fireshot!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
       
        // Setup Firebase
        
        FirebaseApp.configure()
        fs = Fireshot()
        fs.auth()
        
        
        if let button = statusBar.button {
            
            let cloudImage = NSImage(named: NSImage.Name("cloud"))
            button.image = cloudImage
        }
        
        self.createMenu()
    }

    func createMenu(){
        
        
        let menu = NSMenu()
        
        let screenCaptureItem = NSMenuItem(title: "Capture Screen", action: #selector(self.screenCapture), keyEquivalent: "s")
        
        menu.addItem(screenCaptureItem)
        
        statusBar.menu = menu
        
    }
    
    @objc func screenCapture(){
        
       fs.screenCapture()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

