//
//  ViewController.swift
//  Fireshot
//
//  Created by Toan Nguyen Dinh on 1/5/18.
//  Copyright © 2018 Toan Nguyen Dinh. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var fs: Fireshot!
    
    let titleLabel: NSTextField = {
        
       let label = NSTextField(labelWithString: "toan@tabvn.com")
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = NSFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    let header: NSView = {
        
       let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    lazy var selectButton: NSButton = {
        let image = NSImage(named: NSImage.Name("select"))
        let button = NSButton(image: image!, target: self, action: #selector(self.captureSelectScreen))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isBordered = false
        return button
    }()
    
    lazy var fullScreenButton: NSButton = {
        let image = NSImage(named: NSImage.Name("full"))
        let button = NSButton(image: image!, target: self, action: #selector(self.captureFullScreen))
        button.isBordered = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var signOutButton: NSButton = {
        let image = NSImage(named: NSImage.Name("out"))
        let button = NSButton(image: image!, target: self, action: #selector(self.signOut))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isBordered = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
    }
    
    @objc func captureSelectScreen(){
        fs.tooglePopover()
        self.fs.screenCapture()
    }
    @objc func captureFullScreen(){
        
        fs.tooglePopover()
        self.fs.fullScreenCapture()
        
    }
    @objc func signOut(){
        self.fs.signOut()
        self.fs.tooglePopover()

    }
    func setupView(){
        
        view.widthAnchor.constraint(equalToConstant: 200).isActive = true
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(titleLabel)
        view.addSubview(header)
        view.addSubview(signOutButton)
        if let email = fs.getCurrentUserEmail(){
            titleLabel.stringValue = email
        }
        
        titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        signOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        signOutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        signOutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        header.heightAnchor.constraint(equalToConstant: 50).isActive = true
        header.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        header.addSubview(selectButton)
        header.addSubview(fullScreenButton)
        
        selectButton.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 10).isActive = true
        selectButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 10).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        fullScreenButton.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 70).isActive = true
        fullScreenButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 10).isActive = true
    }
    
}
