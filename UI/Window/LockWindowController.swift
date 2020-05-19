//
//  LockWindowController.swift
//  EasyLocker
//
//  Created by Roy Rao on 2020/3/15.
//  Copyright © 2020 RoyRao. All rights reserved.
//

import Cocoa

class KeyWindow: NSPanel {
    override var canBecomeKey: Bool {
        return true
    }
}

class LockWindowController: NSWindowController {
    var passwordView: EnterPasswordView!
    let mainImage = NSImageView.init()
    var constraintL: NSLayoutConstraint? = nil
    var constraintH: NSLayoutConstraint? = nil
    let filename = NSTextField.init()
    let notice = NSTextField.init()
    
    init() {
        let win = KeyWindow.init(contentRect: .init(x: 0, y: 0, width: 300, height: 400),
                                 styleMask: [.closable, .titled, .hudWindow, .utilityWindow],
                                backing: .buffered,
                                defer: true)
        super.init(window: win)
        let customToolbar = NSToolbar.init()
        customToolbar.showsBaselineSeparator = false
        win.backgroundColor = .clear
        win.isMovableByWindowBackground = true
        win.titlebarAppearsTransparent = true
        win.titleVisibility = .hidden
        win.toolbar = customToolbar
        win.animationBehavior = .documentWindow
        win.hidesOnDeactivate = false
        win.center()
        passwordView = EnterPasswordView.init()
        
        addComponents()
        initComponents()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LockWindowController {
    
    private func addComponents() {
        self.window?.contentView?.addSubview(passwordView.view)
        self.window?.contentView?.addSubview(mainImage)
        self.window?.contentView?.addSubview(notice)
        self.window?.contentView?.addSubview(filename)
    }
    
    private func initComponents() {
        mainImage.frame = .init(x: 75, y: 250, width: 150, height: 128.76)
        mainImage.image = NSImage.init(named: "mainImage")
        mainImage.image?.size = .init(width: 150, height: 128.76)
        passwordView.password.delegate = self
        constraintL = passwordView.view.topAnchor.constraint(equalTo: self.window!.contentView!.bottomAnchor, constant: -50)
        constraintH = passwordView.view.topAnchor.constraint(equalTo: self.window!.contentView!.bottomAnchor, constant: -100)
        notice.frame = .init(x: 50, y: 100, width: 240, height: 30)
        notice.translatesAutoresizingMaskIntoConstraints = false
        notice.isEditable = false
        notice.isBordered = false
        notice.isSelectable = false
        notice.usesSingleLineMode = false
        notice.backgroundColor = .clear
        notice.cell?.wraps = true
        notice.cell?.isScrollable = false
        notice.stringValue = "This app is protected by EasyLocker. Provide password before you can access."
        notice.textColor = NSColor.init(hex: "F6F6F6")
        notice.alignment = .right
        filename.frame = .init(x: 50, y: 140, width: 240, height: 30)
        filename.translatesAutoresizingMaskIntoConstraints = false
        filename.isEditable = false
        filename.isBordered = false
        filename.isSelectable = false
        filename.backgroundColor = .clear
        filename.stringValue = "App Store"
        filename.font = NSFont.init(name: "PT Sans", size: 20)
        filename.textColor = NSColor.init(hex: "F6F6F6")
        filename.alignment = .right
    }
    
    private func addConstraints() {
        guard let contentView = window?.contentView else { return }
        constraintL?.isActive = true
        passwordView.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        passwordView.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        passwordView.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        notice.bottomAnchor.constraint(equalTo: passwordView.view.topAnchor, constant: -10).isActive = true
        notice.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -250).isActive = true
        notice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        filename.bottomAnchor.constraint(equalTo: notice.topAnchor, constant: -20).isActive = true
        filename.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    }
    
}

extension LockWindowController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        guard let contentView = self.window?.contentView else { return }
        if passwordView.password.stringValue.count > 0 {
            constraintL?.isActive = false
            constraintH?.isActive = true
        } else {
            constraintH?.isActive = false
            constraintL?.isActive = true
        }
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 0.25
            context.allowsImplicitAnimation = true
            contentView.layoutSubtreeIfNeeded()
        }
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            passwordView.unlock_clicked(nil)
            return true
        }
        return false
    }
    
}
