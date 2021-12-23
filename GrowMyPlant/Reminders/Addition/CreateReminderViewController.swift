import UIKit
import UserNotifications

class CreateReminderViewController: UIViewController {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var selectedDogLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.delegate = self
        allowNotifications()
        setupGestures()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadiuses()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if descriptionTextField.text != "" && selectedDogLabel.text != "select dog" {
            
            guard let title = selectedDogLabel.text else { return }
            guard let body = descriptionTextField.text else { return }
            
            addNotification(title: title, body: body)
            self.dismiss(animated: true)
        }
    }
    
    @objc func selectDogTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: DogSelectorTableViewController.self)
        guard let dogSelectorViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? DogSelectorTableViewController else { return }
        
        dogSelectorViewController.modalPresentationStyle = .popover
        
        let popOverViewContoller = dogSelectorViewController.popoverPresentationController
        popOverViewContoller?.delegate = self
        
        popOverViewContoller?.sourceView = self.selectedDogLabel
        dogSelectorViewController.preferredContentSize = CGSize(width: 250, height: 250)
        
        dogSelectorViewController.selectionDelegate = self
        
        self.present(dogSelectorViewController, animated: true)
        
    }
    
    func allowNotifications() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { settings in
                if settings.authorizationStatus != .authorized {
                    fatalError()
                }
            }
        }
    }
    
    func setCornerRadiuses() {
        self.cancelButton.layer.cornerRadius = 10
        self.addButton.layer.cornerRadius = 10
    }
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectDogTapped))
        tap.numberOfTapsRequired = 1
        self.selectedDogLabel.isUserInteractionEnabled = true
        self.selectedDogLabel.addGestureRecognizer(tap)
    }
    
    func addNotification(title: String, body: String) {
        
        let notificationDate = self.datePicker.date
        
        
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

extension CreateReminderViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

extension CreateReminderViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner])
    }
}

extension CreateReminderViewController: SelectDogDelegate {
    func set(name: String) {
        self.selectedDogLabel.text = name
    }
}
