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

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem.title = "loading"
        statusItem.highlightMode = true
        statusItem.menu = statusMenu

        let menuItem = NSMenuItem()
        menuItem.title = "Quit"
        menuItem.action = Selector("quit:")
        statusMenu.addItem(menuItem)
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "setSSID:", userInfo: nil, repeats: true)
    }

    func setSSID(timer: NSTimer) {
        let ssid: String = currentSSID()
        statusItem.title = ssid.substringToIndex(ssid.startIndex.advancedBy(3))
    }
    
    func currentSSID() -> String {
        let task: NSTask = NSTask()
        task.launchPath = "/usr/sbin/networksetup";
        task.arguments  = ["-getairportnetwork", "en0"]

        let pipe = NSPipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        let outputArray: [String] = output.componentsSeparatedByString(": ")
        
        if (outputArray.count == 2) {
            return outputArray[1]
        } else {
            return "off"
        }
    }

    @IBAction func quit(sender: NSButton) {
        NSApplication.sharedApplication().terminate(self)
    }

}
