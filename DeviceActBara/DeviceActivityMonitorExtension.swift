//
//  DeviceActivityMonitorExtension.swift
//  DeviceActBara
//
//  Created by Muhammad Aliffandy on 13/09/26.
//

import DeviceActivity
import UserNotifications
import Foundation

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        if event.rawValue == "BaraWarningEvent" {
            // 85% waktu tercapai → Kirim notifikasi agar aplikasi utama menyalakan Dynamic Island
            sendNotification(
                identifier: "BaraWarningNotif",
                title: "⏰ Waktumu hampir habis!",
                body: "Masih ada sedikit sisa waktu scrollmu. Siap-siap ya!",
                deepLink: "bara://startliveactivity"
            )
        } else if event.rawValue == "BaraThresholdEvent" {
            // 100% waktu tercapai → Kirim notifikasi "Waktu habis"
            sendNotification(
                identifier: "BaraThresholdNotif",
                title: "🔥 Waktu scrollmu habis!",
                body: "Yuk balik fokus ke kerjaan kamu.",
                deepLink: "bara://timeup"
            )
        }
    }
    
    private func sendNotification(identifier: String, title: String, body: String, deepLink: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = ["deepLink": deepLink]
        
        // Trigger instan (tanpa delay)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notifikasi gagal: \(error.localizedDescription)")
            } else {
                print("✅ Notifikasi '\(identifier)' berhasil dikirim.")
            }
        }
    }
}
