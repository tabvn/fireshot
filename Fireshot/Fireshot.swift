//
//  Fireshot.swift
//  Fireshot
//
//  Created by Toan Nguyen Dinh on 1/4/18.
//  Copyright © 2018 Toan Nguyen Dinh. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage

class Fireshot {
    
    private var tempDir: String!
    private var currentUser: User?
    
    
    init(){
        
        self.tempDir = NSTemporaryDirectory()
    }
    
    func auth(){
        
        let email:String = "toan@tabvn.com"
        let password: String = "12345678"
        
        
        if let _ = self.getCurrentUserId(){
            
            // user already logged we dont need do login any more
            
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                
                print("Login Errror",error)
                return
            }
            
            guard let _user = user else{
                
              
                
                return
            }
            
            self.currentUser = _user
        }
        
    }
    func screenCapture(){
        
        // Implement screen capture use /usr/sbin/screencapture
        
        
        let task = Process()
        
        let timestamp: Int = lround(NSDate().timeIntervalSince1970 * 1000)
        
        let filename = "\(timestamp)_shot.png"
        let destination = self.tempDir + filename
        
        task.launchPath = "/usr/sbin/screencapture"
        
        var arguments = ["-x","-i", "-r"]
        
        arguments.append(destination)
        task.arguments = arguments
        
    
        
        task.launch()
        task.waitUntilExit()
        
        let file = FileManager()
        
        if file.fileExists(atPath: destination){
            
            // file is exist
            
            let fileData: Data = file.contents(atPath: destination)!
            // upload this file data to FIrebase Storage
            let ref = Storage.storage().reference(withPath: "shots")
            
            let metaData = StorageMetadata()
            
            metaData.contentType = "image/png"
            
            ref.child(filename).putData(fileData, metadata: metaData, completion: { (storeMetaData, error) in
                
                // delete file
                
                do{
                    try file.removeItem(atPath: destination)
                }
                catch{
                    print("An error delete file", destination)
                }
                
                
                if let error = error{
                    
                    print("An error saving shot to storage", error)
                    return
                }
                
                
                if let downloadUrl: String = storeMetaData?.downloadURL()?.absoluteString{
                    
                    // show notification to user
                     self.showNotification(title: "Screenshot saved", text: "Screenshot has been copied to your clipboard.", image: fileData)
                    
                    // copy to clipboard
                    
                    let pasteClipBoard = NSPasteboard.general
                    
                    pasteClipBoard.clearContents()
                    pasteClipBoard.setString(downloadUrl, forType: NSPasteboard.PasteboardType.string)
                
                    if let userId = self.getCurrentUserId(){
                        
                        let shot = Shot(file: filename, url: downloadUrl, uid: userId)
                        shot.save()
                    }
                    
                    
                }
                
            })
            
            
            
            
        }
    
    
        
       
        
        
        
    }
    
    func getCurrentUserId() -> String?{
        
        return Auth.auth().currentUser?.uid
        
        
    }
    
    func showNotification(title: String, text: String, image: Data) -> Void {
        
        let notification = NSUserNotification()
    
        notification.title = "Fireshot"
        notification.informativeText = text
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.contentImage = NSImage(data: image)
        NSUserNotificationCenter.default.deliver(notification)
        
    }
    
    
    
}
