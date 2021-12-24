import Foundation
import UserNotifications

struct NotificationManager {
    
    static let shared = NotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
          completion(granted)
        }
    }
    
    func addNotification(title: String, body: String, date: Date) {
        let notificationDate = date
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: notificationDate)
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components,
                                                    repeats: false)
        
        let request = UNNotificationRequest(identifier: title,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
    
    
}
