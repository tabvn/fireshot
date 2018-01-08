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
    

    
    //
    var fs: Fireshot!
    let viewWidth: CGFloat = 250
    let viewHeight: CGFloat = 250
    
    var selected: Shot! = nil
    
    var commandKeyPressed: Bool = false

    var selectedCells: [shotTableCell] = [shotTableCell]()
    
    // Menu options for select shot/copy/delete  ...
    
    lazy var shotCellMenu: NSMenu = {
        
        let menu = NSMenu()
        
        menu.addItem(withTitle: "Open", action: #selector(self.openShotLink), keyEquivalent: "")
        menu.addItem(withTitle: "Copy URL to clipboard", action: #selector(self.copyLink), keyEquivalent: "")
        menu.addItem(withTitle: "Delete", action: #selector(self.deleteShot), keyEquivalent: "")
        
        return menu
        
    }()
    
    lazy var mainMenu: NSMenu = {
        
        let menu = NSMenu()
        
        var email: String? = "My Account"
        if let fs = self.fs{
            email = fs.getCurrentUserEmail()
            
        }
        
        menu.addItem(withTitle: email!, action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "Sign Out", action: #selector(self.signOut), keyEquivalent: "")
        menu.addItem(withTitle: "Quit Fireshot", action: #selector(self.quitApp), keyEquivalent: "")
        
        
        return menu
        
        
    }()
    
    @objc func recordingScreen(){
        
        
        self.fs.tooglePopover()
        
        let deadline = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: deadline) {
           
            self.fs.startScreenRecording()
        }
        
    }
    lazy var addMenu: NSMenu = {
        
        
        let menu = NSMenu()
        
        menu.addItem(withTitle: "Full Screen Capture", action: #selector(self.captureFullScreen), keyEquivalent: "")
        let pasteItem = NSMenuItem(title: "Paste text from clipboard", action: #selector(self.pasteFromClipboard), keyEquivalent: "")
        pasteItem.allowsKeyEquivalentWhenHidden = true
        pasteItem.accessibilityAllowedValues()
        menu.addItem(withTitle: "Screen Recoding", action: #selector(self.recordingScreen), keyEquivalent: "")
       
        menu.addItem(pasteItem)
        
        return menu
        
    }()
    
    var scrollViewTableView: NSScrollView = {
        
        let sv = NSScrollView()
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.wantsLayer = true
        
        sv.layer?.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 0.8)
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
        
        table.doubleAction = #selector(self.rowDoubleLick)
        table.allowsMultipleSelection = true
        
        
        
        
        
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
    
    lazy var addButton: NSButton = {
        let image = NSImage(named: NSImage.Name("add"))
        let button = NSButton(image: image!, target: self, action: #selector(self.openAddMenu))
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
    
    
    lazy var dropView: FileDropView = {
        
        let coder = NSCoder()
        
        let frame = NSRect()
        let view = FileDropView(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        setupView()
        
        loadTableData()
    }
    
    @objc func copyLink(){
        
        fs.copyToClipboard(text: self.selected.url)
        fs.tooglePopover()
        
    }
    @objc func deleteShot(){
        
        self.selected.delete()
        self.selected = nil
    }
    @objc func openShotLink(){
        
        self.fs.openLink(shot: self.selected)
        
    }
    
    @objc func pasteFromClipboard(){
        
        fs.pasteFromClipboard()
        
    }
    @objc func openAddMenu(sender: NSButton){
        
        let p = NSPoint(x: sender.frame.origin.x, y: sender.frame.origin.y - (sender.frame.height / 2))
        self.addMenu.popUp(positioning: nil, at: p, in: sender.superview)
        
    }
    @objc func quitApp(){
        
        NSApplication.shared.terminate(self)
    }
    @objc func openMenu(sender: NSButton){
        
        let p = NSPoint(x: sender.frame.origin.x, y: sender.frame.origin.y - (sender.frame.height / 2))
        self.mainMenu.popUp(positioning: nil, at: p, in: sender.superview)
        
        
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
    
    @objc func rowDoubleLick(){
        
        let rowIndex:Int = self.tableView.clickedRow
        let shots = fs.getShots()
        let shot: Shot = shots[rowIndex]
        self.fs.openLink(shot: shot)
        
    }
    
    
    @objc func signOut(){
        self.fs.signOut()
        self.fs.tooglePopover()
        
    }
    func setupView(){
        
        
        dropView.fs = self.fs
        
        view.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        
        view.addSubview(dropView)
        
        dropView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        dropView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        dropView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        dropView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        dropView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        dropView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        
        
        dropView.addSubview(header)
        dropView.addSubview(headerLine)

        
        header.topAnchor.constraint(equalTo: dropView.topAnchor, constant: 0).isActive = true
        header.leftAnchor.constraint(equalTo: dropView.leftAnchor, constant: 0).isActive = true
        header.rightAnchor.constraint(equalTo: dropView.rightAnchor, constant: 0).isActive = true
        header.heightAnchor.constraint(equalToConstant: 30).isActive = true
        header.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        
        
        
        
        
        headerLine.topAnchor.constraint(equalTo: header.bottomAnchor, constant: -1).isActive = true
        headerLine.leftAnchor.constraint(equalTo: dropView.leftAnchor, constant: 0).isActive = true
        headerLine.rightAnchor.constraint(equalTo: dropView.rightAnchor, constant: 0).isActive = true
        headerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        headerLine.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        
        
        header.addSubview(selectButton)
        header.addSubview(addButton)
        
        selectButton.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 10).isActive = true
        selectButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 5).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addButton.leftAnchor.constraint(equalTo: selectButton.rightAnchor, constant: 10).isActive = true
        addButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 5).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        header.addSubview(configButton)
        configButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 5).isActive = true
        configButton.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -10).isActive = true
        configButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        configButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        scrollViewTableView.documentView = tableView
        scrollViewTableView.contentInsets = NSEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        dropView.addSubview(scrollViewTableView)
        
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
        
        if  let shot: Shot = shots[row]{
            tableCellView.setShot(shot: shot)
        }
        
        
        
        tableCellView.viewVC = self
        
        
        return tableCellView
    }
    
    
    
    override func viewWillDisappear() {
        fs.mainTable = nil
    }
    
   
   
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        
        
        for selectedCell in self.selectedCells{
            selectedCell.isSelected = false
            selectedCell.updateLayout()
        }
        self.selectedCells.removeAll()
        
        
        for (_, index) in self.tableView.selectedRowIndexes.enumerated(){
            
            let cell = self.tableView.view(atColumn: 0, row: index, makeIfNecessary: true) as! shotTableCell
            cell.isSelected = true
            cell.updateLayout()
            self.selectedCells.append(cell)
            
        }
       
    
            
    }
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
    
        return true
    }
    
    
    
    
    override func keyDown(with event: NSEvent) {
        
        // v bind paste event
        
        if event.keyCode == 9 && self.commandKeyPressed == true{

            // do paste event
            self.fs.pasteFromClipboard()
        }
        if event.keyCode == 51 && self.selectedCells.count > 0{
            
            
            for cell in self.selectedCells{
                let shot = cell.shot
                shot?.delete()
                
            
            }
            
            self.selectedCells.removeAll()
    
            
            
        }
    }
    
    
   
    override func flagsChanged(with event: NSEvent) {
        
        let flagEvent = event.modifierFlags.intersection(NSEvent.ModifierFlags.deviceIndependentFlagsMask)
        
       
        if flagEvent == .command{
           
            self.commandKeyPressed = true
        }
        else{
            
            self.commandKeyPressed = false
        }
    }
    
    
    
    
}
