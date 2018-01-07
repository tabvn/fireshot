//
//  LoginViewController.swift
//  Fireshot
//
//  Created by Toan Nguyen Dinh on 1/5/18.
//  Copyright © 2018 Toan Nguyen Dinh. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController, NSTextFieldDelegate {

    var fs: Fireshot! = nil
    private var messageAdded: Bool = false
    
    let viewWidth: CGFloat = 250
    let viewHeight: CGFloat = 160
    let headerLine:NSView = {
        
        let box = NSView()
        box.translatesAutoresizingMaskIntoConstraints = false
        
        box.wantsLayer = true
        
        box.layer?.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        
        return box
    }()
    
    let header: NSView = {
        
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: NSTextField = {
        
       let label = NSTextField(labelWithString: "Sign In")
        label.font = NSFont.systemFont(ofSize: 14)
        label.textColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alignment = NSTextAlignment.center
        
        return label
    }()
    
    let formView: NSView = {
        
        
        let view = NSView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.layer?.backgroundColor = CGColor.white
        
        return view
        
    }()
    
    let emailTextfield: NSTextField = {
        
        let tf = NSTextField()
        
        tf.wantsLayer = true
        tf.isBordered = false
        tf.layer?.borderWidth = 1
        tf.layer?.cornerRadius = 0
        tf.layer?.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholderString = "Email"
        tf.tag = 0
        tf.sendAction(on: NSEvent.EventTypeMask.mouseEntered)
        
        return tf
    }()
    
    let passwordTextField: NSTextField = {
        
        let tf = NSSecureTextField()
        tf.wantsLayer = true
        tf.isBordered = false
        tf.layer?.borderWidth = 1
        tf.layer?.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        tf.layer?.cornerRadius = 0
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholderString = "Password"
        tf.tag = 1
        tf.sendAction(on: NSEvent.EventTypeMask.mouseEntered)
        
        
        return tf
    }()
    
    lazy var button: NSButton = {
        
        let button = NSButton(title: "Sign In", target: self, action: #selector(self.submit))
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.wantsLayer = true
        button.isBordered = false
        button.layer?.borderWidth = 1
        button.layer?.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        button.layer?.cornerRadius = 0
        
        
        return button
    }()
    
   
    
    lazy var mainMenu: NSMenu = {
        
        let menu = NSMenu()
        
        menu.addItem(withTitle: "Create an account", action: #selector(self.register), keyEquivalent: "")
        menu.addItem(withTitle: "Quit Fireshot", action: #selector(self.quit), keyEquivalent: "")
        
        return menu
        
    }()
    lazy var configButton: NSButton = {
        let image = NSImage(named: NSImage.Name("config"))
        let button = NSButton(image: image!, target: self, action: #selector(self.openMenu))
        button.isBordered = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageScaling = .scaleAxesIndependently
        button.isTransparent = true
        
        return button
    }()
    
    @objc func register(){
        
        
        let register = RegisterViewController()
        
        register.fs = fs
        
        self.fs.pushViewController(from: self, destination: register)
        
    }
    @objc func openMenu(sender: NSButton){
        
        
       let p: NSPoint = NSPoint(x: sender.frame.origin.x, y: sender.frame.origin.y - (sender.frame.height/2))
       self.mainMenu.popUp(positioning: nil, at: p, in: sender.superview)
        
    }
    @objc func quit(){
        
        NSApplication.shared.terminate(self)
    }
    @objc func submit(){
        
        self.removeMessage()
        

        
        guard let email = self.emailTextfield.stringValue as String?,  let password: String = self.passwordTextField.stringValue as String? else{
            
            return
        }
        
        self.button.title = "Please wait..."
        self.button.isEnabled = false
        
   
        fs.auth(email: email, password: password) { (user, error) in
            
            self.button.title = "Sign In"
            self.button.isEnabled = true
            if let _ = error{
                
                
               
                self.addMessage(text: "Login Error, Try again!")
                
                return
            }
            
            self.removeMessage()
            
            self.fs.tooglePopover()
          
            
        }
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Do view setup here.
        view.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        
        emailTextfield.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(header)
        view.addSubview(headerLine)
        
        
        
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        header.heightAnchor.constraint(equalToConstant: 30).isActive = true
        header.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        
        
        
        headerLine.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 0).isActive = true
        headerLine.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        headerLine.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        headerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        headerLine.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        
        
        header.addSubview(configButton)
        
        configButton.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -10).isActive = true
        configButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 5).isActive = true
        configButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        configButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        
        header.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo:header.leftAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: configButton.leftAnchor, constant: 0).isActive = true
        
        
        
        view.addSubview(formView)
        formView.topAnchor.constraint(equalTo: headerLine.bottomAnchor, constant: 0).isActive = true
        formView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        formView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        formView.rightAnchor.constraint(equalTo: headerLine.rightAnchor, constant: 0).isActive = true
        
        
        formView.addSubview(emailTextfield)
        formView.addSubview(passwordTextField)
        
        formView.addSubview(button)
    
        
        let parentView: NSView = formView
        emailTextfield.topAnchor.constraint(equalTo:headerLine.bottomAnchor, constant: 20).isActive = true
        emailTextfield.leftAnchor.constraint(equalTo:parentView.leftAnchor, constant: 10).isActive = true
        emailTextfield.heightAnchor.constraint(equalToConstant: 25).isActive = true
        emailTextfield.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -10).isActive = true
        
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 10).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo:parentView.leftAnchor, constant: 10).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -10).isActive = true
        
        button.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        button.leftAnchor.constraint(equalTo:parentView.leftAnchor, constant: 10).isActive = true
        button.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -10).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
    }
    
    
    func addMessage(text: String){
      
        
        self.emailTextfield.layer?.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 0.5)
        self.passwordTextField.layer?.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 0.5)
        
        
        
    }
    
    func removeMessage(){
        
        self.emailTextfield.layer?.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        self.passwordTextField.layer?.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        
      
      
    }
    override func controlTextDidEndEditing(_ obj: Notification) {
       
        if let tf: NSTextField = obj.object as? NSTextField{
            
            if tf.tag == 1{
                
                let email: String = emailTextfield.stringValue
                let password: String = passwordTextField.stringValue
                
                if password != "" && email != ""{
                    self.submit()
                }
                
            }
        }
        
       
        
        
    }
    
    
    
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        return true
    }
    
    
    
}
