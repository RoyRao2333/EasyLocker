//
//  CheckPanel.swift
//
//  Created by Roy Rao on 2020/3/17.
//  Copyright © 2020 RoyRao. All rights reserved.
//

import Cocoa

class CheckPanel: NSWindowController {
    var checkmarkView: CheckmarkView!
    let stringText = NSTextField.init()
    
    init() {
        let win = NSPanel.init(contentRect: .init(x: 300, y: 300, width: 150, height: 150),
                               styleMask: [.fullSizeContentView],
                                backing: .buffered,
                                defer: true)
        super.init(window: win)
        win.isMovable = false
        win.contentView?.wantsLayer = true
        
        initial()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CheckPanel {
    
    private func initial() {
        guard let contentView = self.window?.contentView, let screenRect = NSScreen.main?.frame, let panel = self.window else {
            return
        }
        panel.setFrameOrigin(.init(x: screenRect.width / 2 - panel.frame.width / 2,
                                   y: screenRect.height / 6))
        
        checkmarkView = CheckmarkView.init(frame: contentView.frame)
        checkmarkView.wantsLayer = true
        checkmarkView.setColor(color: NSColor.init(hex: "55C348").cgColor)
        contentView.addSubview(checkmarkView)
        
        stringText.frame = .init(x: 0, y: 0, width: 90, height: 25)
        stringText.stringValue = "Unlocked"
        stringText.font = NSFont.init(name: "PT Sans Bold", size: 20)
        stringText.textColor = NSColor.init(hex: "8F8F8F")
        stringText.backgroundColor = .clear
        stringText.isEditable = false
        stringText.isBordered = false
        stringText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stringText)
    }
    
    private func addConstraints() {
        guard let contentView = self.window?.contentView else { return }
        stringText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stringText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    func startCheck() {
        checkmarkView.startCheckmark()
    }
    
}
