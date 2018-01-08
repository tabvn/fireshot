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
    
    private var storageRef = Storage.storage().reference(withPath: "shots")
    private let ref: DatabaseReference = Database.database().reference(withPath: "shots")
    private var tempDir: String!
    private var currentUser: User?
    private var menuButton: NSButton!
    private var popover: NSPopover!
    private var activeVC: NSViewController!
    private var connected: Bool = false

    let expectedExt = ["jpg", "jpeg", "JPG", "png", "txt", "doc", "docx", "html", "pdf", "xls", "xlsx", "json", "zip", "gz", "tar.gz", "plist", "js", "ico", "psd", "csv"]
    
    var mainTable: NSTableView! = nil
    
    var shots: [Shot] = [Shot]()
    
    
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
    
    
    func pushViewController(from: NSViewController, destination: NSViewController){
        
 
    
        self.popover.contentViewController = destination
        self.popover.show(relativeTo: self.menuButton.bounds, of: self.menuButton, preferredEdge: NSRectEdge.minY)

    }
    func getShots() -> [Shot] {
        return self.shots
    }
    
    func extensitionAllowed(url: URL) -> Bool{
        
        let suffix = url.pathExtension
        for ext in self.expectedExt {
            if ext.lowercased() == suffix {
                return true
            }
        }
        return false
    }
    
    func pasteFromClipboard(){
        
       
        
        guard let type: String = NSPasteboard.general.pasteboardItems?.first?.types.first?.rawValue else{
            
            return
        }
        
        switch type {
            
        case "public.file-url":
            
            let pasteboard = NSPasteboard.general.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType"))
            guard let fileItems: NSArray = pasteboard as? NSArray else{
                
                return
            }
            
            for item in fileItems{
                let filePath = item as! String
                let fileUrl: URL = NSURL(fileURLWithPath: filePath) as URL
                
                if self.extensitionAllowed(url: fileUrl){
                    
                    
                    let filename = fileUrl.lastPathComponent
                    guard let userId = self.getCurrentUserId() else{
                        return
                    }
                    let shot: Shot = Shot(title: filename, file: filename, type: "file", url: "", uid: userId, id: nil, timestamp: nil)
                    
                    let fileNametoSave = shot.id + filename
                    self.changeMenuImage(imageName: "cloud_upload")
                    self.storageUploadFileUrl(filename: fileNametoSave, url: fileUrl, meta: nil, complete: { (file, error) in
                        
                        
                        if let _ = error {
                            self.changeMenuImage(imageName: "cloud_error")
                            return
                        }
                        
                        
                        self.changeMenuImage(imageName: "cloud")
                        
                        if error == nil && file != nil{
                            shot.setFilename(name: fileNametoSave)
                            
                            guard let downloadUrl = file?.downloadURL()?.absoluteString, let fileType = file?.contentType else{
                                
                                return
                            }
                            shot.setType(type: fileType)
                            shot.setDownloadUrl(urlString: downloadUrl)
                            shot.save()
                            
                            self.showNotification(title: "Fireshot", text: "\(filename) uploaded successfuly", image: nil)
                        }
                        
                    })
                    
                }
                
                
                
                
            }
            
           
            

            
            
            
            
            break
            
        case "public.utf8-plain-text":
            
            
            self.uploadTextContent(html: false)
            
            break
            
        case  "public.html":
            
            self.uploadTextContent(html: true)
            
            break
            
            
        default:
            
            
         print("not recognited")
        }
        
        return
        
        
        
        
        
    }
    
    
    func clipboardHtmlContent() -> Data?{
        
        guard let html: Data = NSPasteboard.general.pasteboardItems?.first?.data(forType: NSPasteboard.PasteboardType.html) else {
            
            return nil
        }
        
        return html
    }
    
    func uploadTextContent(html: Bool){
        
        guard let userId = self.getCurrentUserId() else {
            
           return
        }
        
        let shot = Shot(title: html ? "HTML clipboard" : "Plain Text Clipboard", file: "", type: html ? "text/html" : "text/plain", url: "", uid: userId, id: nil, timestamp: nil)
        var filename: String!
        
        
        
        var data: Data?
        let meta: StorageMetadata! = StorageMetadata()
        
        
        if html{
            meta.contentType = "text/html"
            filename = shot.id + ".html"
            data = self.clipboardHtmlContent()
            
        }else{
            
            data = self.clipboardContent()?.data(using: String.Encoding(rawValue: String.Encoding.unicode.rawValue))
            meta.contentType = "text/plain"
            filename = shot.id + ".txt"
        }
        
        
        

        if let data = data{
            
            self.changeMenuImage(imageName: "cloud_upload")
            
            self.storageUpload(filename: filename, data: data, meta: meta, complete: { (url, error) in
                
                if let _ = error {
                    self.changeMenuImage(imageName: "cloud_error")
                    return
                }
                
                guard let url = url else  {
                    
                    return
                }
                self.changeMenuImage(imageName: "cloud")
                self.copyToClipboard(text: url)
                self.showNotification(title: "Clipboard saved successful", text: "URl of your content has been copied to your clipboard. \(filename)", image: data)
                
                shot.setDownloadUrl(urlString: url)
                shot.setFilename(name: filename)
                shot.save()
            })
        }
        
        
        
        
        
        
    }
    
    func storageUploadFileUrl(filename: String, url: URL, meta: StorageMetadata?, complete: @escaping (_ file: StorageMetadata?, _ error: Error?) -> Void){
        
        guard let userId = self.getCurrentUserId() else {
            
            return complete(nil, nil)
        }
        
        
        storageRef.child(userId).child(filename).putFile(from: url, metadata: meta) { (file, error) in
            
            if let error = error{
                self.changeMenuImage(imageName: "cloud_error")
                return complete(nil, error)
            }
            
            

            return complete(file, nil)
            
        }
        
    }
    
    
    
    func storageUpload(filename: String, data: Data, meta: StorageMetadata?, complete: @escaping (_ downloadURL: String?, _ error: Error?) -> Void){
        
        guard let userId = self.getCurrentUserId() else {
            
            return complete(nil, nil)
        }
        storageRef.child(userId).child(filename).putData(data, metadata: meta) { (file, error) in
            
            if let error = error{
                
                self.changeMenuImage(imageName: "cloud_error")
                return complete(nil, error)
            }
            
            guard let file = file, let fileUrl = file.downloadURL()?.absoluteString else{
                
                return complete(nil, nil)
            }
            
            return complete(fileUrl, nil)
        }
    }
    func clipboardContent() -> String?
    {
    
    
        return NSPasteboard.general.pasteboardItems?.first?.string(forType: .string)
    }
    
    func copyToClipboard(text: String){
        
        let pasteClipBoard = NSPasteboard.general
        
        pasteClipBoard.clearContents()
        pasteClipBoard.setString(text, forType: NSPasteboard.PasteboardType.string)
        
       
        
    }
    
    func openLink(shot: Shot){
        
        if let url = URL(string: shot.url), NSWorkspace.shared.open(url) {
            self.tooglePopover()
        }
    }
    func onShotAdded(){
        
        // offline detection
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                // connected
                self.connected = true
                self.changeMenuImage(imageName: "cloud")
            } else {
                self.connected = false
                self.changeMenuImage(imageName: "cloud_disconnect")
                
            }
        })
        
        
        
        guard let _ = self.getCurrentUser() else {
            return
        }
        
       
        
       
        guard let userId = self.getCurrentUserId() else {
            return
        }
        
        
        
        ref.child(userId).queryLimited(toLast: 10).observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            
            let data: [String: Any] = snapshot.value as! [String : Any]
            guard let timestamp: Double = data["timestamp"] as? Double, let id: String = snapshot.key as String? , let file: String = (data["file"] as? String), let url: String = (data["url"] as? String), let userId: String = data["uid"] as? String else{
                
                return
            }
            
            var title: String = file
            var type: String = "unknown"
            
            if let _title: String = data["title"] as? String{
                
                title = _title
            }
            if let _type: String = data["type"] as? String{
                
                type = _type
            }
            
            let shot = Shot(title: title , file: file, type: type, url: url, uid: userId, id: id, timestamp: timestamp)

            
            self.shots.insert(shot, at: 0)
            
       
            if self.mainTable != nil {
                
                
                DispatchQueue.main.async {
                    
                    let indexSet:IndexSet = NSIndexSet(index: 0) as IndexSet
                    self.mainTable.insertRows(at: indexSet, withAnimation: NSTableView.AnimationOptions.slideDown)
                    
                    self.mainTable.reloadData()
                }
               // self.mainTable.reloadData()
            }
            
        }
        
        ref.child(userId).observe(DataEventType.childRemoved) { (snapshot) in
            
            let key: String = snapshot.key
            
            let result = self.shots.filter{ $0.id != key }
            
            self.shots = result
            if self.mainTable != nil{
                
                DispatchQueue.main.async {
                     self.mainTable.reloadData()
                }
               
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
    
    func register(email: String, password: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void){
        
        self.signOut()
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error{
                
                return completion(nil, error)
            }
            
            return completion(user, error)
            
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
    func changeMenuImage(imageName: String){
        
        let cloudImage = NSImage(named: NSImage.Name(imageName))
        self.menuButton.image = cloudImage
    }
    func saveScreenshot(destination:String!){
        
        guard let userId = self.getCurrentUserId() else {
            
            return
        }
        let file = FileManager()
        
        if file.fileExists(atPath: destination){
            
            // file is exist
            self.changeMenuImage(imageName: "cloud_upload")
            let fileData: Data = file.contents(atPath: destination)!
            // upload this file data to FIrebase Storage
            
            
            let metaData = StorageMetadata()
            
            metaData.contentType = "image/png"
            
            do{
                try file.removeItem(atPath: destination)
            }
            catch{
                print("An error delete file", destination)
            }
            
            
            let shot = Shot(title: "Screen Shot", file: "", type: "image/png", url: "", uid: userId, id: nil, timestamp: nil)
            let filename = shot.id + ".png"
            shot.setFilename(name: filename)
            
        
            
            
            storageRef.child(userId).child(filename).putData(fileData, metadata: metaData, completion: { (storeMetaData, error) in
                
                // delete file
                
                
                
                if let error = error{
                    
                    print("An error saving shot to storage", error)
                    
                    self.changeMenuImage(imageName: "cloud_error")
                    return
                    
                    
                }
                self.changeMenuImage(imageName: "cloud")
                
                
                
                if let downloadUrl: String = storeMetaData?.downloadURL()?.absoluteString{
                    
                    // show notification to user
                    self.showNotification(title: "Fireshot upload successful", text: "Screenshot has been copied to your clipboard. \(filename)", image: fileData)
                    
                    // copy to clipboard
                    
                    self.copyToClipboard(text: downloadUrl)
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
    
    func showNotification(title: String, text: String, image: Data?) -> Void {
        
        let notification = NSUserNotification()
    
        
        
        notification.title = title
        notification.informativeText = text
        notification.soundName = NSUserNotificationDefaultSoundName
        if let image = image{
            notification.contentImage = NSImage(data: image)
        }
        
        NSUserNotificationCenter.default.deliver(notification)
        
    }
    func setMenuButton(button: NSButton){
        
        self.menuButton = button
    }
    
    func getCurrentUser() -> User?{
        
        return Auth.auth().currentUser
    }
    func signOut(){
        
        self.shots.removeAll()
        self.ref.removeAllObservers()
        
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
