//
//  AppDelegate.swift
//  EasyLocker
//
//  Created by Roy Rao on 2020/3/14.
//  Copyright © 2020 RoyRao. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let lockWindow = LockWindowController.init()
    let observer = NSWorkspace.shared.notificationCenter
    var statusItem: NSStatusItem? = nil
    var customMenu: NSMenu? = nil
    var editAppMenu: NSMenu? = nil
    var appDict: [[String: String]] = []


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if UserDefaults.standard.value(forKey: "Apps") != nil {
            appDict = UserDefaults.standard.object(forKey: "Apps") as! [[String : String]]
        }
        self.menuConfig()
        self.createButtonStatusBar()
        observer.addObserver(self, selector: #selector(appWillLaunch(notification:)),
                             name: NSWorkspace.willLaunchApplicationNotification, object: nil)
        lockWindow.window?.makeKeyAndOrderFront(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        let statusBar = NSStatusBar.system
        statusBar.removeStatusItem(statusItem!)
//        UserDefaults.standard.set(appDict, forKey: "Apps")
    }

}

extension AppDelegate {
    
    func createButtonStatusBar() {
        let statusBar = NSStatusBar.system
        let item = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        item.button?.image = NSImage.init(named: "locker")
        item.button?.image?.size = .init(width: 20, height: 20)
        item.button?.image?.isTemplate = true
        item.menu = customMenu
        statusItem = item
    }
    
    func menuConfig() {
        customMenu = NSMenu.init()
        let firstLevelMenuItem = NSMenuItem.init()
        firstLevelMenuItem.submenu = customMenu
        let aboutItem = NSMenuItem.init(title: "About EasyLocker", action: #selector(about_clicked(_:)), keyEquivalent: "")
        let editItem = NSMenuItem.init(title: "Locked Apps", action: nil, keyEquivalent: "")
        let preferencesItem = NSMenuItem.init(title: "Preferences...", action: #selector(preferences_clicked(_:)), keyEquivalent: "P")
        let quitItem = NSMenuItem.init(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "")
        editAppMenu = NSMenu.init()
        editItem.submenu = editAppMenu
        let addItem = NSMenuItem.init(title: "Add...", action: #selector(add_clicked(_:)), keyEquivalent: "")
        let unlockItem = NSMenuItem.init(title: "Unlock all", action: nil, keyEquivalent: "")
        
        customMenu?.addItem(aboutItem)
        customMenu?.addItem(.separator())
        customMenu?.addItem(editItem)
        customMenu?.addItem(preferencesItem)
        customMenu?.addItem(.separator())
        customMenu?.addItem(quitItem)
        customMenu?.delegate = self
        editAppMenu?.addItem(addItem)
        editAppMenu?.addItem(unlockItem)
        editAppMenu?.addItem(.separator())
        
        if appDict.count > 0 {
            for app in appDict {
                let newItem = NSMenuItem.init(title: app["name"]!, action: #selector(item_clicked(_:)),
                                              keyEquivalent: "")
                editAppMenu?.addItem(newItem)
            }
        }
    }
    
    @IBAction func about_clicked(_ sender: AnyObject) {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(self)
    }
    
    @IBAction func preferences_clicked(_ sender: AnyObject) {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func add_clicked(_ sender: AnyObject) {
        NSApp.activate(ignoringOtherApps: true)
        let fileManager = FileManager.default
        let openPanel = NSOpenPanel.init()
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["app"]
        openPanel.begin { (response) in
            guard let path = openPanel.url?.path else { return }
            let name = fileManager.displayName(atPath: path)
            for index in 0..<self.appDict.count {
                if self.appDict[index]["name"]! == name {
                    let alert = NSAlert.init()
                    alert.messageText = "This app is already in protection."
                    alert.informativeText = "Don't need to add it twice."
                    alert.runModal()
                    return
                }
            }
            let newItem = NSMenuItem.init(title: name, action: #selector(self.item_clicked(_:)), keyEquivalent: "")
            self.editAppMenu?.addItem(newItem)
            self.appDict.append(["name": name, "path": path])
            UserDefaults.standard.set(self.appDict, forKey: "Apps")
        }
    }
    
    @IBAction func item_clicked(_ sender: AnyObject) {
        NSApp.activate(ignoringOtherApps: true)
        let item = sender as! NSMenuItem
        let alert = NSAlert.init()
        alert.messageText = "Do you want to RUN the app or UNLOCK it?"
        alert.addButton(withTitle: "Run")
        alert.addButton(withTitle: "Unlock")
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            for index in 0..<appDict.count {
                if appDict[index]["name"]! == item.title {
                    let path = appDict[index]["path"]!
                    NSWorkspace.shared.openFile(path)
                    break
                }
            }
        } else {
            editAppMenu?.removeItem(item)
            for index in 0..<appDict.count {
                if appDict[index]["name"]! == item.title {
                    appDict.remove(at: index)
                    break
                }
            }
            print("Unlocked")
        }
        UserDefaults.standard.set(appDict, forKey: "Apps")
    }
    
    @objc func appWillLaunch(notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        let name = info["NSApplicationName"] as! String
//        let appPID = info["NSApplicationProcessIdentifier"] as! Int32
//        let path = info["NSApplicationPath"] as! String
        lockWindow.filename.stringValue = name
    }
    
    func save2Plist() {
        let fileManager = FileManager.default
        let path = Bundle.main.path(forResource: "", ofType: "")
    }
    
}

extension AppDelegate: NSMenuDelegate {
    
    func menu(_ menu: NSMenu, willHighlight item: NSMenuItem?) {
        if item?.title == "Edit Apps" {
            if editAppMenu!.items.count > 3 {
                editAppMenu?.item(withTitle: "Unlock all")?.action = #selector(about_clicked(_:))
            } else {
                editAppMenu?.item(withTitle: "Unlock all")?.action = nil
            }
        }
    }
    
}

