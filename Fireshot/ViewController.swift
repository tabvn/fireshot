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
    let viewWidth: CGFloat = 250
    let viewHeight: CGFloat = 250
    
    
    lazy var mainMenu: NSMenu = {
       
        let menu = NSMenu()
        
        var email: String? = "My Account"
        if let fs = self.fs{
            email = fs.getCurrentUserEmail()
            
        }
       
        menu.addItem(withTitle: email!, action: #selector(self.openProfile), keyEquivalent: "")
        menu.addItem(withTitle: "Sign Out", action: #selector(self.signOut), keyEquivalent: "")
        menu.addItem(withTitle: "Quit Fireshot", action: #selector(self.quitApp), keyEquivalent: "")
        
        
        return menu
        
        
    }()
    var scrollViewTableView: NSScrollView = {
        
        let sv = NSScrollView()
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
        
    }()
    
    
    
    lazy var tableView: NSTableView = {
        
        let table = NSTableView(frame: .zero)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.rowSizeStyle = .small
        table.rowHeight = 50
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "column"))
        
        table.headerView = nil
        column.width = self.viewWidth
        table.addTableColumn(column)
        
        
        
        table.intercellSpacing = NSSize(width: 0, height: 1.0)
        table.gridColor = NSColor.clear
        table.gridStyleMask = .solidHorizontalGridLineMask
        table.usesAlternatingRowBackgroundColors = false
        
        
        
        
        return table
       
        
    }()
    
    
    
    let header: NSView = {
        
       let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerLine:NSView = {
        
       let box = NSView()
       box.translatesAutoresizingMaskIntoConstraints = false
       
       box.wantsLayer = true
        
        box.layer?.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        
       return box
    }()
    lazy var selectButton: NSButton = {
        let image = NSImage(named: NSImage.Name("select"))
        
        let button = NSButton(image: image!, target: self, action: #selector(self.captureSelectScreen))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isBordered = false
        button.imageScaling = .scaleAxesIndependently
        
        
        return button
    }()
    
    lazy var fullScreenButton: NSButton = {
        let image = NSImage(named: NSImage.Name("full"))
        let button = NSButton(image: image!, target: self, action: #selector(self.captureFullScreen))
        button.isBordered = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageScaling = .scaleAxesIndependently
        return button
    }()
    
    lazy var configButton: NSButton = {
        let image = NSImage(named: NSImage.Name("config"))
        let button = NSButton(image: image!, target: self, action: #selector(self.openMenu))
        button.isBordered = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageScaling = .scaleAxesIndependently
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        loadTableData()
    }
    @objc func quitApp(){
        
        NSApplication.shared.terminate(self)
    }
    @objc func openMenu(sender: NSButton){
        
        
        
        
        let p = NSPoint(x: sender.frame.origin.x, y: sender.frame.origin.y - (sender.frame.height / 2))
        self.mainMenu.popUp(positioning: nil, at: p, in: sender.superview)
        
        
    }
    @objc func openProfile(){
        
        
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
        
        
        view.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        
        view.addSubview(header)
        view.addSubview(headerLine)
       
        
        
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        header.heightAnchor.constraint(equalToConstant: 30).isActive = true
        header.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        
       
        
        headerLine.topAnchor.constraint(equalTo: header.bottomAnchor, constant: -1).isActive = true
        headerLine.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        headerLine.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        headerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        headerLine.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        
        
        header.addSubview(selectButton)
        header.addSubview(fullScreenButton)
        
        selectButton.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 10).isActive = true
        selectButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 5).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        fullScreenButton.leftAnchor.constraint(equalTo: selectButton.rightAnchor, constant: 10).isActive = true
        fullScreenButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 5).isActive = true
        fullScreenButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        fullScreenButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        header.addSubview(configButton)
        configButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 5).isActive = true
        configButton.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -10).isActive = true
        configButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        configButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        tableView.delegate = self
        tableView.dataSource = self
    
        scrollViewTableView.documentView = tableView
        scrollViewTableView.contentInsets = NSEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        view.addSubview(scrollViewTableView)
        
        scrollViewTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollViewTableView.topAnchor.constraint(equalTo: headerLine.bottomAnchor, constant: 0).isActive = true
        scrollViewTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollViewTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        
        
        
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
