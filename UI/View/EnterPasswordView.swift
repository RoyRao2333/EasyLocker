//
//  EnterPasswordView.swift
//  EasyLocker
//
//  Created by Roy Rao on 2020/3/15.
//  Copyright © 2020 RoyRao. All rights reserved.
//

import Cocoa

class EnterPasswordView: NSViewController {
    let checkPanel = CheckPanel.init()
    let separator = NSBox.init()
    let password = NSSecureTextField.init()
    let lockImage = NSImageView.init()
    let unlockBtn = NSButton.init()
    let showPw = NSButton.init()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let view = NSVisualEffectView.init(frame: .init(x: 0, y: 0, width: 300, height: 50))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.layer?.backgroundColor = .clear
        view.layer?.cornerRadius = 12
        view.layer?.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.state = .active
        view.blendingMode = .behindWindow
        view.material = .mediumLight
        self.view = view
        
        addComponents()
        initComponents()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EnterPasswordView {
    
    private func addComponents() {
        self.view.addSubview(separator)
        self.view.addSubview(password)
        self.view.addSubview(lockImage)
        self.view.addSubview(showPw)
        self.view.addSubview(unlockBtn)
    }
    
    private func initComponents() {
        separator.boxType = .custom
        separator.frame = .init(x: 10, y: 50, width: 280, height: 1)
        separator.borderColor = NSColor.init(hex: "979797")
        separator.translatesAutoresizingMaskIntoConstraints = false
        password.frame = .init(x: 40, y: 62, width: 200, height: 20)
        password.focusRingType = .none
        password.isBordered = false
        password.backgroundColor = .clear
        password.appearance = NSAppearance.init(named: .aqua)
        password.translatesAutoresizingMaskIntoConstraints = false
        let pwAttr = [NSAttributedString.Key.foregroundColor: NSColor.init(hex: "656060"),
                          NSAttributedString.Key.font: NSFont.systemFont(ofSize: 14)]
        password.placeholderAttributedString = NSAttributedString.init(string: "Password",
                                                                       attributes: pwAttr)
        lockImage.frame = .init(x: 10, y: 65, width: 15, height: 15)
        lockImage.image = NSImage.init(named: "lock")
        lockImage.image?.size = .init(width: 15, height: 15)
        lockImage.translatesAutoresizingMaskIntoConstraints = false
        showPw.frame = .init(x: 10, y: 15, width: 150, height: 20)
        showPw.setButtonType(.switch)
        showPw.appearance = NSAppearance.init(named: .aqua)
        let switchAttr = [NSAttributedString.Key.foregroundColor: NSColor.init(hex: "282626"),
                          NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12)]
        showPw.attributedTitle = NSAttributedString.init(string: " Also remove from protection",
                                                         attributes: switchAttr)
        showPw.translatesAutoresizingMaskIntoConstraints = false
        unlockBtn.frame = .init(x: 0, y: 0, width: 40, height: 20)
        unlockBtn.translatesAutoresizingMaskIntoConstraints = false
        unlockBtn.bezelStyle = .inline
        unlockBtn.appearance = NSAppearance.init(named: .aqua)
//        unlockBtn.title = NSLocalizedString("Unlock", comment: "")observer
        
        unlockBtn.focusRingType = .none
        unlockBtn.attributedTitle = NSAttributedString.init(string: "Unlo", attributes: switchAttr)
//        unlockBtn.wantsLayer = true
//        unlockBtn.layer?.backgroundColor = NSColor.init(hex: "FCFCFC").cgColor
//        unlockBtn.layer?.cornerRadius = 6
        unlockBtn.target = self
        unlockBtn.action = #selector(unlock_clicked(_:))
    }
    
    private func addConstraints() {
        let mainView = self.view
        let constraints = [
            lockImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            lockImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 18),
            separator.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            separator.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            separator.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 50),
            password.leadingAnchor.constraint(equalTo: lockImage.trailingAnchor, constant: 5),
            password.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -70),
            password.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 18),
            showPw.topAnchor.constraint(equalTo: separator.topAnchor, constant: 18),
            showPw.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            unlockBtn.leadingAnchor.constraint(equalTo: password.trailingAnchor, constant: 5),
            unlockBtn.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            unlockBtn.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 18)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @IBAction private func showPW_clicked(_ sender: NSButton) {
        
    }
    
    @IBAction func unlock_clicked(_ sender: NSButton?) {
        if password.stringValue == "1111" {
            self.view.window?.close()
            checkPanel.window?.makeKeyAndOrderFront(self)
            checkPanel.startCheck()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.checkPanel.window?.close()
            }
        } else {
            password.shake()
        }
    }
    
}
