//
//  ExtensionDelegate.swift
//  CalendarTest WatchKit Extension
//
//  Created by Rohan Malik on 2/4/22.
//

import Foundation
import WatchKit
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                reloadActiveComplications()
                backgroundTask.setTaskCompletedWithSnapshot(false)
            default:
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    func applicationDidFinishLaunching() {
        scheduleRefresh()
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { success, error in
            if success { print("Authorized") } else if let error = error { print(error.localizedDescription) }
        }
        scheduleSportsNotification()
        scheduleLunchNotification()
        let ud = UserDefaults.standard
        guard let temp = ud.stringArray(forKey: "eventsList") else { return }
        print("-- Before --")
        print(eventsList)
        print("-- Temp -- ")
        print(temp)
        for str in temp {
            let comps = str.split(separator: "-")
            print("- Comps -")
            print(comps)
            print("- Block Event -")
            print(blockEvent(String(comps[2])).toString())
            eventsList[Int(String(comps[0]))!][Int(String(comps[1]))!]?.append(blockEvent(String(comps[2])))
        }
        print("-- After --")
        print(eventsList)
    }
    
    func applicationWillResignActive() {
        let ud = UserDefaults.standard
        var allEvents: [String] = []
        for (i, month) in eventsList.enumerated() {
            for key in month.keys {
                for event in month[key]! {
                    allEvents.append("\(i)-\(key)-\(event.toString())")
                }
            }
        }
        print(allEvents)
        ud.set(allEvents, forKey: "eventsList")
    }
}
