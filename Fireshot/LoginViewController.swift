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
    
    let titleLabel: NSTextField = {
        
       let label = NSTextField(labelWithString: "Sign In")
        label.font = NSFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alignment = NSTextAlignment.center
        
        return label
    }()
    
    let emailTextfield: NSTextField = {
        
        let tf = NSTextField()
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholderString = "Email"
        
        return tf
    }()
    
    let passwordTextField: NSTextField = {
        
        let tf = NSSecureTextField()
        
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
        
        return btn
    }()
    
    let message: NSTextField = {
        
        let label = NSTextField(labelWithString: "")
        label.font = NSFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alignment = NSTextAlignment.center
        
        return label
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
        
   
        fs.auth(email: email, password: password) { (user, error) in
            
            if let _ = error{
                self.message.textColor = .red
                self.addMessage(text: "Login Error, Try again!")
                
                return
            }
            
            
            self.fs.tooglePopover()
          
            
        }
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Do view setup here.
        view.widthAnchor.constraint(equalToConstant: 200).isActive = true
        view.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        view.addSubview(titleLabel)
        

        
        view.addSubview(emailTextfield)
        view.addSubview(passwordTextField)
        
        view.addSubview(button)
        view.addSubview(quitButton)
        
        let parentView: NSView = view
        
        titleLabel.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo:parentView.leftAnchor, constant: 10).isActive = true
        //textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -10).isActive = true
        
        emailTextfield.topAnchor.constraint(equalTo:titleLabel.bottomAnchor, constant: 20).isActive = true
        emailTextfield.leftAnchor.constraint(equalTo:parentView.leftAnchor, constant: 10).isActive = true
        //textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        emailTextfield.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -10).isActive = true
        
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 5).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo:parentView.leftAnchor, constant: 10).isActive = true
        //textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -10).isActive = true
        
        button.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        button.leftAnchor.constraint(equalTo:parentView.leftAnchor, constant: 10).isActive = true
        
        quitButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        quitButton.rightAnchor.constraint(equalTo:parentView.rightAnchor, constant: -10).isActive = true
        
        
    }
    
    func addMessage(text: String){
        let parentView = self.view
        
        view.addSubview(message)
        message.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -10).isActive = true
        message.leftAnchor.constraint(equalTo:parentView.leftAnchor, constant: 10).isActive = true
        //textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        message.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -10).isActive = true
        
        message.stringValue = text
        
        messageAdded = true
        view.layout()
        
    }
    
    func removeMessage(){
        
        if messageAdded {
            message.stringValue = ""
            message.removeFromSuperview()
           
            
            messageAdded = false
        }
      
    }
    
    
}
