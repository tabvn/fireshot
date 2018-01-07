//
//  LoginViewController.swift
//  Fireshot
//
//  Created by Toan Nguyen Dinh on 1/5/18.
//  Copyright © 2018 Toan Nguyen Dinh. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {

    var fs: Fireshot! = nil
    private var messageAdded: Bool = false
    
    let viewWidth: CGFloat = 250
    let viewHeight: CGFloat = 180
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
    
    let emailTextfield: NSTextField = {
        
        let tf = NSTextField()
        
        tf.wantsLayer = true
        tf.isBordered = false
        tf.layer?.borderWidth = 1
        tf.layer?.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholderString = "Email"
        
        return tf
    }()
    
    let passwordTextField: NSTextField = {
        
        let tf = NSSecureTextField()
        tf.wantsLayer = true
        tf.isBordered = false
        tf.layer?.borderWidth = 1
        tf.layer?.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholderString = "Password"
        
        return tf
    }()
    
    lazy var button: NSButton = {
        
        let btn = NSButton(title: "Sign In", target: self, action: #selector(self.submit))
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        
        return btn
    }()
    
    lazy var quitButton: NSButton = {
        
        let btn = NSButton(title: "Quit", target: self, action: #selector(self.quit))
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isBordered = false
        btn.setAccessibilityIndex(2)
        return btn
    }()
    
    
    @objc func quit(){
        
        NSApplication.shared.terminate(self)
    }
    @objc func submit(){
        
        self.removeMessage()
        
        if let _ = fs.getCurrentUserId(){
           
            fs.signOut()
        }
        
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
        
        view.addSubview(titleLabel)
        

        
        view.addSubview(emailTextfield)
        view.addSubview(passwordTextField)
        
        view.addSubview(button)
        view.addSubview(quitButton)
        
        let parentView: NSView = view
        
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
        
        
        
        titleLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo:header.leftAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: header.rightAnchor, constant: 0).isActive = true
        
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
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        quitButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5).isActive = true
        quitButton.rightAnchor.constraint(equalTo:parentView.rightAnchor, constant: -10).isActive = true
        
        
    }
    
    
    func addMessage(text: String){
        let parentView = self.view
        
        
        
        self.emailTextfield.layer?.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
        self.passwordTextField.layer?.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
        
        
        
    }
    
    func removeMessage(){
        
        self.emailTextfield.layer?.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        self.passwordTextField.layer?.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        
        
       
      
    }
    
    
}
