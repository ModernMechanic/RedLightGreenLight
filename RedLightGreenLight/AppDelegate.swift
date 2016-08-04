//
//  AppDelegate.swift
//  RedLightGreenLight
//
//  Created by dustin d'avignon on 6/13/16.
//  Copyright © 2016 Modern Mechanic. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // set up statusBar and path to blink1-tool
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    let path = NSBundle.mainBundle().pathForResource("blink1-tool", ofType: "")

    
    // function to execute blink1-tool commands
    func executeCommand(args: [String]) -> String {
        
        let task:NSTask = NSTask()
        let pipe:NSPipe = NSPipe()
        
        task.launchPath = path
        task.arguments = args
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: NSUTF8StringEncoding)
      
        return String(output)
        
    }
    
    // green, red, off commands
    func greenLight(sender: AnyObject){
        executeCommand(["--green"])
    }
    
    func redLight(sender: AnyObject){
        executeCommand(["--red"])
    }

    func ExitNow(sender: AnyObject){
        executeCommand(["--off"])
        exit(0)
    }
    
    
    // initial setup
    func applicationDidFinishLaunching(aNotification: NSNotification) {

        //status button
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
        }
        
        // configure menu options
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Available (Green)", action: #selector(AppDelegate.greenLight(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Busy (Red)", action: #selector(AppDelegate.redLight(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.ExitNow(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separatorItem())
        statusItem.menu = menu
        
        // start device with green
        executeCommand(["--green"])
        
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

