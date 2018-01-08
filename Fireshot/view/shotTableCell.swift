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
    
    var isSelected: Bool = false
    
    let titleColor: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    let subTitleColor: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    
    let cellView: NSView = {
        let v = NSView()
        v.wantsLayer = true
        v.layer?.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.02)
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    lazy var moreOptionButton: NSButton = {
       
        let image = NSImage(named: NSImage.Name("more"))
        let button = NSButton(image: image!, target: self, action: #selector(self.openMenu))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isBordered = false
        button.wantsLayer = true
        button.layer?.backgroundColor = CGColor.clear
        
        
        
        return button
    }()
    
  
    
    lazy var titleLabel: NSTextField = {
        
       
        let label = NSTextField()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        label.isBordered = false
        label.wantsLayer = true
        label.backgroundColor = NSColor.clear
        label.textColor = self.titleColor
        label.alignment = .left
        label.font = NSFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    lazy var dateTimeLabel: NSTextField = {
        
        
        let label = NSTextField(labelWithString: "")
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = NSFont.systemFont(ofSize: 10)
        label.textColor = self.subTitleColor
        
        
        return label
    }()

    @objc func openMenu(sender: NSButton){
        let p = NSPoint(x: sender.frame.origin.x, y: sender.frame.origin.y - 0)
        self.viewVC.selected = self.shot
        self.viewVC.shotCellMenu.popUp(positioning: nil, at: p, in: sender.superview)
        
    }


    override init(frame frameRect: NSRect) {
       
        super.init(frame: frameRect)
    
        self.addSubview(cellView)
        self.addSubview(titleLabel)
        self.wantsLayer = true
        
        cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        
        cellView.addSubview(moreOptionButton)
        
        let parentView: NSView = cellView
        
        moreOptionButton.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 0).isActive = true
        
        moreOptionButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        moreOptionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        moreOptionButton.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: 0).isActive = true
        

        
        titleLabel.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: moreOptionButton.leftAnchor, constant: 0).isActive = true
        
        cellView.addSubview(dateTimeLabel)
        dateTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        dateTimeLabel.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 10).isActive = true
        dateTimeLabel.rightAnchor.constraint(equalTo: moreOptionButton.leftAnchor, constant: 0).isActive = true
  
      
        
        
        
    }
    
    
    
    func setShot(shot: Shot){
        
  
        self.shot = shot
        
        guard let timestamp = self.shot.timestamp else{
            
            return
        }
       
        
        dateTimeLabel.stringValue = timestamp.getDateTimeString()
        titleLabel.stringValue = shot.title //timestamp.getDateTimeString()
        
        
        
    }

    func updateLayout(){
        
        if self.isSelected{
            
            titleLabel.textColor = NSColor.white
            dateTimeLabel.textColor = NSColor.white
            
        }else{
            
            titleLabel.textColor = titleColor
            dateTimeLabel.textColor = subTitleColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

       
        
    }
    
    
    
}
