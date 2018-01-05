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
import FirebaseDatabase

class Fireshot {
    
    private var tempDir: String!
    private var currentUser: User?
    private var menuButton: NSButton!
    private var popover: NSPopover!
    private var activeVC: NSViewController!
    
    var mainTable: NSTableView! = nil
    
    private var shots: [Shot] = [Shot]()
    
    
    init(){
        
        if let _ = self.getCurrentUser(){
            let mainVC = ViewController()
            mainVC.fs = self
            self.activeVC = mainVC
        }else{
            let loginVC = LoginViewController()
            loginVC.fs = self
            self.activeVC = loginVC
            
        }
        
        
        self.tempDir = NSTemporaryDirectory()
        self.onShotAdded()
    }
    
    func getShots() -> [Shot] {
        return self.shots
    }
    
    
    func onShotAdded(){
        
        guard let _ = self.getCurrentUser() else {
            return
        }
        let ref = Database.database().reference(withPath: "shots")
        
       
        guard let userId = self.getCurrentUserId() else {
            return
        }
        
        ref.child(userId).queryLimited(toLast: 5).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            let data: [String: Any] = snapshot.value as! [String : Any]
            guard let timestamp: Double = data["timestamp"] as? Double, let id: String = snapshot.key , let file: String = (data["file"] as? String), let url: String = (data["url"] as? String), let userId: String = data["uid"] as? String else{
                
                return
            }
            let shot = Shot(file: file, url: url, uid: userId, id: id, timestamp: timestamp)
           
            
           /* Storage.storage().reference(withPath: "shots").child(file).downloadURL(completion: { (imageUrl, error) in
                if let imageUrl = imageUrl{
                  
                    let image = NSImage(contentsOf: imageUrl)
                    shot.setImage(image: image!)
                    
                    if self.mainTable != nil{
                        
                        self.mainTable.reloadData()
                    }
                    
                }
            })*/
            
            self.shots.append(shot)
            
       
            if self.mainTable != nil {
                
                print("Reload Data!!!!!!")
                self.mainTable.reloadData()
            }
            
        }
        
        ref.child(userId).observe(DataEventType.childRemoved) { (snapshot) in
            
            let key: String = snapshot.key
            
            let result = self.shots.filter{ $0.id != key }
            
            self.shots = result
            if self.mainTable != nil{
                self.mainTable.reloadData()
            }

        }
        
    }
    
    func auth(email: String, password: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void){
        
     
        
        
        if let _ = self.getCurrentUserId(){
            
            // user already logged we dont need do login any more
            let currentUser = self.getCurrentUser()
            return completion(currentUser, nil)
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                
                print("Login Errror",error)
                
                return completion(nil, error)
            }
            
            guard let _user = user else{
                
              
                
                return
            }
            
            
            self.currentUser = _user
            self.onShotAdded()
            return completion(_user, nil)
        }
        
    }
    
    @objc func fullScreenCapture(){
        
        
       /* let img = CGDisplayCreateImage(CGMainDisplayID())
        let dest = CGImageDestinationCreateWithURL(destination, kUTTypePNG, 1, nil)
        CGImageDestinationAddImage(dest!, img!, nil)
        CGImageDestinationFinalize(dest!)
        
        return destination*/
        
        let image = CGDisplayCreateImage(CGMainDisplayID())
        
        let timestamp: Int = lround(NSDate().timeIntervalSince1970 * 1000)
        let filename = "\(timestamp)_shot.png"
        
        let path = self.tempDir + filename
        
        let url: NSURL = NSURL(fileURLWithPath: path)
        
        guard let destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, nil) else{
            
            return
        }
      
        
        CGImageDestinationAddImage(destination, image!, nil)
        CGImageDestinationFinalize(destination)
    
        self.saveScreenshot(destination: path)
        
        
        
    }
    
    
    @objc func screenCapture(){
        
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
        
        
        self.saveScreenshot(destination: destination)
    
        
       // save screen
        self.saveScreenshot(destination: destination)
        
        
    }
    func saveScreenshot(destination:String!){
        
        guard let userId = self.getCurrentUserId() else {
            
            return
        }
        let file = FileManager()
        
        if file.fileExists(atPath: destination){
            
            // file is exist
            
            let fileData: Data = file.contents(atPath: destination)!
            // upload this file data to FIrebase Storage
            let ref = Storage.storage().reference(withPath: "shots")
            
            let metaData = StorageMetadata()
            
            metaData.contentType = "image/png"
            
            do{
                try file.removeItem(atPath: destination)
            }
            catch{
                print("An error delete file", destination)
            }
            
            let cloudImage = NSImage(named: NSImage.Name("cloud_upload"))
            self.menuButton.image = cloudImage
            let shot = Shot(file: "", url: "", uid: userId, id: nil, timestamp: nil)
            let filename = shot.id + ".png"
            shot.setFilename(name: filename)
            
        
            
            
            ref.child(filename).putData(fileData, metadata: metaData, completion: { (storeMetaData, error) in
                
                // delete file
                
                self.menuButton.image = NSImage(named: NSImage.Name("cloud"))
                
                if let error = error{
                    
                    print("An error saving shot to storage", error)
                    
                    
                }
                
                
                
                if let downloadUrl: String = storeMetaData?.downloadURL()?.absoluteString{
                    
                    // show notification to user
                    self.showNotification(title: "Screenshot saved", text: "Screenshot has been copied to your clipboard.", image: fileData)
                    
                    // copy to clipboard
                    
                    let pasteClipBoard = NSPasteboard.general
                    
                    pasteClipBoard.clearContents()
                    pasteClipBoard.setString(downloadUrl, forType: NSPasteboard.PasteboardType.string)
                    
                    shot.setDownloadUrl(urlString: downloadUrl)
                    shot.save() // save shot to firebase
                    
                    
                
                }
                
                
            })
            
            
            
            
        }
        
    }
    
    func getCurrentUserId() -> String?{
        
        return Auth.auth().currentUser?.uid
        
        
    }
    
    func getCurrentUserEmail() -> String?{
        
        return Auth.auth().currentUser?.email
        
    }
    
    func showNotification(title: String, text: String, image: Data) -> Void {
        
        let notification = NSUserNotification()
    
        notification.title = "Fireshot"
        notification.informativeText = text
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.contentImage = NSImage(data: image)
        NSUserNotificationCenter.default.deliver(notification)
        
    }
    func setMenuButton(button: NSButton){
        
        self.menuButton = button
    }
    
    func getCurrentUser() -> User?{
        
        return Auth.auth().currentUser
    }
    func signOut(){
        
        do{
            try Auth.auth().signOut()
        }
        catch{
            print("Logout error")
        }
        
    }
    
    func setPopover(popover: NSPopover){
        
        self.popover = popover
    }
    
    func tooglePopover(){
        
        if self.popover.isShown{
            
            self.popover.close()
        }else{
            
            if let _ =  self.getCurrentUser() {
                
                let mainVC = ViewController()
                mainVC.fs = self
                self.activeVC = mainVC
                
                
            }else{
                
                let loginVC = LoginViewController()
                loginVC.fs = self
                self.activeVC = loginVC
                
            }
            
            self.popover.contentViewController = self.activeVC
            self.popover.show(relativeTo: self.menuButton.bounds, of: self.menuButton, preferredEdge: NSRectEdge.minY)
        }
        
        
    }
    

    @objc func exitApp(){
    
        NSApplication.shared.terminate(self)
    }
    @objc func showMainViewController(show: Bool){
        
        if self.popover.isShown{
            self.popover.close()
        }
        let VC = ViewController()
        VC.fs = self
        self.activeVC = VC
        
        self.popover.contentViewController = VC
        if show{
             self.popover.show(relativeTo: self.menuButton.bounds, of: self.menuButton, preferredEdge: NSRectEdge.minY)
        }
       
        
    }
    @objc func showLoginViewController(show: Bool){
        
        if self.popover.isShown{
            self.popover.close()
        }
        let loginVC = LoginViewController()
        loginVC.fs = self
        self.activeVC = loginVC
        
        popover.contentViewController = loginVC
        if show{
            popover.show(relativeTo: self.menuButton.bounds, of: self.menuButton, preferredEdge: NSRectEdge.minY)
        }
       
    }

    
    
}



extension Double{
    
    func getDateTimeString() -> String{
       
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
       
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
}
