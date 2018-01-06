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
    var viewVC: ViewController! = nil

    lazy var moreOptionButton: NSButton = {
       
        let button = NSButton(title: "More", target: self, action: #selector(self.openMenu))
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
    

    @objc func openMenu(sender: NSButton){
        let p = NSPoint(x: sender.frame.origin.x, y: sender.frame.origin.y - 0)
        self.viewVC.selected = self.shot
        self.viewVC.shotCellMenu.popUp(positioning: nil, at: p, in: sender.superview)
        
    }


    override init(frame frameRect: NSRect) {
       
        super.init(frame: frameRect)
    
        
        self.addSubview(titleLabel)
        self.wantsLayer = true
        self.layer?.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.05)

        self.addSubview(moreOptionButton)
        moreOptionButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        moreOptionButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        moreOptionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        moreOptionButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        

        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: moreOptionButton.leftAnchor, constant: 0).isActive = true
  
      
        
        
        
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
