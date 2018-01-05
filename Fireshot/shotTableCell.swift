//
//  shotTableCell.swift
//  Fireshot
//
//  Created by Toan Nguyen Dinh on 1/5/18.
//  Copyright © 2018 Toan Nguyen Dinh. All rights reserved.
//

import Cocoa

class shotTableCell: NSTableCellView {

    var shot: Shot! = nil
    
    
    lazy var openButton: NSButton = {
        
        let button = NSButton(title: "Open", target: self, action: #selector(self.openLink))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isBordered = false
        return button
    }()
    
    lazy var titleLabel: NSButton = {
        
        let button = NSButton(title: "Open", target: self, action: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isBordered = false
        return button
    }()
    
    
    var image: NSImageView = {
    
        let img = NSImage(named: NSImage.Name("cloud"))
        let imgView = NSImageView()
        imgView.image = img
        imgView.wantsLayer = true
        
        imgView.layer?.backgroundColor = .clear
        
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        return imgView
        
    }()
    
    
    @objc func openLink(){
        
    
        if let url = URL(string: self.shot.url), NSWorkspace.shared.open(url) {
            
        }
        
    }
   
    override init(frame frameRect: NSRect) {
       
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = .clear
        
        self.addSubview(titleLabel)
       
        /*
        self.addSubview(image)
        image.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        image.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        image.widthAnchor.constraint(equalToConstant: 30).isActive = true
        image.heightAnchor.constraint(equalToConstant: 30).isActive = true
        */
        
        
        self.addSubview(openButton)
        openButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        openButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        openButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        openButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.openButton.leftAnchor, constant: 0).isActive = true
  
      
        
        
        
    }
    
    
    
    func setShot(shot: Shot){
        
  
        self.shot = shot
        
        guard let timestamp = self.shot.timestamp else{
            
            return
        }
       
        
        titleLabel.title = timestamp.getDateTimeString()
        
        /*if shot.image != nil {
            image.image = shot.image
        }*/
        
        
        
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

       
        
    }
    
}
