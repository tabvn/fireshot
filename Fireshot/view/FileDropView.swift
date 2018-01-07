//
//  FileDropView.swift
//  Fireshot
//
//  Created by Toan Nguyen Dinh on 1/7/18.
//  Copyright © 2018 Toan Nguyen Dinh. All rights reserved.
//

import Cocoa

class FileDropView: NSView {

    var filePath: String?
   
    
    var fs: Fireshot! = nil
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        
        registerForDraggedTypes([NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.fileURL])
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        
    }
    
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            //self.layer?.backgroundColor = NSColor.blue.cgColor
            return .copy
        } else {
            return NSDragOperation()
        }
    }
    
    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = board[0] as? String
            else { return false }
    
        return self.extensitionAllowed(url: URL(fileURLWithPath: path))
        
    }
    
    func extensitionAllowed(url: URL) -> Bool{
        
        let suffix = url.pathExtension
        for ext in self.fs.expectedExt {
            if ext.lowercased() == suffix {
                return true
            }
        }
        return false
    }
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }
        
    
        self.filePath = path
        
        for item in pasteboard{
            let filePath = item as! String
            let fileUrl: URL = NSURL(fileURLWithPath: filePath) as URL
            
            if self.extensitionAllowed(url: fileUrl){
                
                let filename = fileUrl.lastPathComponent
                guard let userId = self.fs.getCurrentUserId() else{
                    return true
                }
                let shot: Shot = Shot(title: filename, file: filename, type: "file", url: "", uid: userId, id: nil, timestamp: nil)
                
                let fileNametoSave = shot.id + filename
                fs.changeMenuImage(imageName: "cloud_upload")
                fs.storageUploadFileUrl(filename: fileNametoSave, url: fileUrl, meta: nil, complete: { (file, error) in
                    
                    self.fs.changeMenuImage(imageName: "cloud")
                    
                    if error == nil && file != nil{
                        shot.setFilename(name: fileNametoSave)
                        
                        guard let downloadUrl = file?.downloadURL()?.absoluteString, let fileType = file?.contentType else{
                            
                            return
                        }
                        shot.setType(type: fileType)
                        shot.setDownloadUrl(urlString: downloadUrl)
                        shot.save()
                        
                        self.fs.showNotification(title: "Fireshot", text: "\(filename) uploaded successfuly", image: nil)
                    }
                    
                })
            }
            
            
           
        }
        
        
        return true
    }
    
}

