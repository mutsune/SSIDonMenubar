//
//  AppDelegate.swift
//  SSIDonMenubar
//
//  Created by nakayama on 1/8/16.
//  Copyright © 2016 mutsune. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem = NSStatusBar.system.statusItem(withLength: -1)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.title = "loading"
        statusItem.highlightMode = true
        statusItem.menu = statusMenu

        let menuItem = NSMenuItem()
        menuItem.title = "Quit"
        menuItem.action = #selector(AppDelegate.quit)
        statusMenu.addItem(menuItem)

        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AppDelegate.setSSID), userInfo: nil, repeats: true)
    }

    @objc func setSSID(timer: Timer) {
        let ssid: String = currentSSID()
        statusItem.title = String(ssid.prefix(3))
    }

    func currentSSID() -> String {
        let task: Process = Process()
        task.launchPath = "/usr/sbin/networksetup";
        task.arguments  = ["-getairportnetwork", "en0"]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: NSString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        let outputArray: [String] = output.components(separatedBy: ": ")
        
        if (outputArray.count == 2) {
            return outputArray[1]
        } else {
            return "off"
        }
    }

    @IBAction func quit(sender: NSButton) {
        NSApplication.shared.terminate(self)
    }

}
