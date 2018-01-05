//
//  ViewController.swift
//  Fireshot
//
//  Created by Toan Nguyen Dinh on 1/5/18.
//  Copyright © 2018 Toan Nguyen Dinh. All rights reserved.
//

import Cocoa
import FirebaseDatabase

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    var fs: Fireshot!
    
    var scrollViewTableView: NSScrollView = {
        
        let sv = NSScrollView()
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
        
    }()
    
    
    let tableView: NSTableView = {
        
        let table = NSTableView(frame: .zero)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.rowSizeStyle = .small
        table.rowHeight = 50
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "column"))
        table.headerView = nil
        column.width = 200
        table.addTableColumn(column)
        
        
        return table
       
        
    }()
    
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
        
        loadTableData()
    }
    
    @objc func captureSelectScreen(){
        fs.tooglePopover()
        self.fs.screenCapture()
    }
    @objc func captureFullScreen(){
        
        fs.tooglePopover()
        
        let deadline: DispatchTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.fs.fullScreenCapture()
            
        }
    
        
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
        header.heightAnchor.constraint(equalToConstant: 30).isActive = true
        header.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        header.addSubview(selectButton)
        header.addSubview(fullScreenButton)
        
        selectButton.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 0).isActive = true
        selectButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 0).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        fullScreenButton.leftAnchor.constraint(equalTo: selectButton.rightAnchor, constant: 0).isActive = true
        fullScreenButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 0).isActive = true
        
        
        //view.addSubview(tableView)
        
        
        tableView.delegate = self
        tableView.dataSource = self
    
        scrollViewTableView.documentView = tableView
        scrollViewTableView.contentInsets = NSEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        view.addSubview(scrollViewTableView)
        
        scrollViewTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollViewTableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 0).isActive = true
        scrollViewTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollViewTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        
        
        
    }
    
    func loadTableData(){
        
        self.fs.mainTable = tableView
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return fs.getShots().count
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        let tableCellView = shotTableCell()
        
        let shots = fs.getShots()
        
        let shot: Shot = shots[row]
        
        tableCellView.setShot(shot: shot)
        
        return tableCellView
    }
    
    override func viewWillDisappear() {
        fs.mainTable = nil
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
    
}
