//
//  Shot.swift
//  Fireshot
//
//  Created by Toan Nguyen Dinh on 1/4/18.
//  Copyright © 2018 Toan Nguyen Dinh. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage


class Shot{
    
    private var ref: DatabaseReference!
    let id: String!
    var file:String!
    var url:String!
    let uid: String!
    let timestamp: Double!
    var image: NSImage! = nil
    
    init(file: String, url: String, uid: String, id: String?, timestamp: Double?) {
        
        self.ref = Database.database().reference(withPath: "shots")
        if id == nil{
             self.id = self.ref.childByAutoId().key
        }else{
            self.id = id
        }
       
        if timestamp == nil{
          self.timestamp = NSDate().timeIntervalSince1970
        }else{
            self.timestamp = timestamp
        }
        self.file = file
        self.url = url
        self.uid = uid
        
    }
    
    func setFilename(name: String){
    
        self.file = name
    }
    func setDownloadUrl(urlString: String){
        self.url = urlString
    }
    func setImage(image: NSImage){
        
        self.image = image
    }
    
    func delete(){
        
        self.ref.child(self.uid).child(self.id).removeValue()
        Storage.storage().reference(withPath: "shots").child(self.uid).child(self.file).delete { (error) in
            
        }
        
    }
    func save(){
        
        let shot: [String: Any] = [
            "file": self.file,
            "url": self.url,
            "uid": self.uid,
            "timestamp": self.timestamp
        ]
        
       // save to firebase db
        
        self.ref.child(self.uid).child(self.id).setValue(shot) { (error, databaseRef) in
           
            if let error = error{
                print("Debug: saving the shot with error ", error )
            }
            
        }
    }
}

















