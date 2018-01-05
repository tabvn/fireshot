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
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {


    let statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var button: NSButton!
    var fs: Fireshot!
    
    
   
    func applicationDidFinishLaunching(_ aNotification: Notification) {
       
        // Setup Firebase
        
        FirebaseApp.configure()
        fs = Fireshot()
        
        fs.auth()
        
        button = statusBar.button
        let cloudImage = NSImage(named: NSImage.Name("cloud"))
        button.image = cloudImage
        
        fs.setMenuButton(button: button)
        self.createMenu()
        
    
    
       

    }
    


    

    func createMenu(){
        
        
        let menu = NSMenu()
        let screenshotSubMenu = NSMenu()
        
        let selectionCaptureItem = NSMenuItem(title: "Selection", action: #selector(self.screenCapture), keyEquivalent: "6")
        
        let fullScreenCaptureItem = NSMenuItem(title: "Full Screen", action: #selector(self.fullScreenCapture), keyEquivalent: "7")
        
        
        
        fullScreenCaptureItem.keyEquivalentModifierMask = [.command, .shift]
        selectionCaptureItem.keyEquivalentModifierMask = [.command, .shift]
        selectionCaptureItem.allowsKeyEquivalentWhenHidden = true
        fullScreenCaptureItem.allowsKeyEquivalentWhenHidden = true
        
        
        screenshotSubMenu.addItem(selectionCaptureItem)
        screenshotSubMenu.addItem(fullScreenCaptureItem)
        
        let screenshotItem = NSMenuItem(title: "Screenshot", action: #selector(self.screenCapture), keyEquivalent: "")
        
        menu.addItem(screenshotItem)
        menu.setSubmenu(screenshotSubMenu, for: screenshotItem)
        
        
        let exitAppItem = NSMenuItem(title: "Quit Fireshot", action: #selector(self.exitApp), keyEquivalent: "")
        
        
        menu.addItem(exitAppItem)
        
        
        statusBar.menu = menu
        
    }
    
    @objc func exitApp(){
        
        NSApplication.shared.terminate(self)
    }
    @objc func screenCapture(){
        
        
    
        fs.screenCapture()
    }
    @objc func fullScreenCapture(){
        
        fs.fullScreenCapture()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

