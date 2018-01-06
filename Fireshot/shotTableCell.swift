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
        button.wantsLayer = true
        button.layer?.backgroundColor = CGColor.clear
        
        
        return button
    }()
    
    lazy var deleteButton: NSButton = {
        
        
        let button = NSButton(title: "Delete", target: self, action: #selector(self.deleteItem))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isBordered = false
        button.wantsLayer = true
        button.layer?.backgroundColor = CGColor.clear
        
        
        return button
    }()
    
    
    lazy var titleLabel: NSButton = {
        
       
        let button = NSButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.bezelStyle = .texturedSquare
        button.isBordered = false
        button.wantsLayer = true
        button.layer?.backgroundColor = .clear
        button.cell?.isBordered = false
        
    
        
        
        button.alignment = .left
        button.font = NSFont.systemFont(ofSize: 12)
        return button
    }()
    

    
    @objc func deleteItem(){
        
        self.shot.delete()
    }
    @objc func openLink(){
        
    
        if let url = URL(string: self.shot.url), NSWorkspace.shared.open(url) {
            
        }
        
    }
   
    override init(frame frameRect: NSRect) {
       
        super.init(frame: frameRect)
    
        
        self.addSubview(titleLabel)
        self.wantsLayer = true
        self.layer?.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.05)

        self.addSubview(openButton)
        openButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        openButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        openButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        self.addSubview(deleteButton)
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        deleteButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: openButton.leftAnchor, constant: 0).isActive = true
        
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.deleteButton.leftAnchor, constant: 0).isActive = true
  
      
        
        
        
    }
    
    
    
    func setShot(shot: Shot){
        
  
        self.shot = shot
        
        guard let timestamp = self.shot.timestamp else{
            
            return
        }
       
        
    
        titleLabel.title = timestamp.getDateTimeString()
        
        
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

       
        
    }
    
}
