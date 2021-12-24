import UIKit
import UserNotifications

class CreateReminderViewController: UIViewController {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var selectedDogLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allowNotifications()
        setupGestures()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadiuses()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismissWithAnimation()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if descriptionTextField.text != "" && selectedDogLabel.text != "select dog" {
            
            guard let title = selectedDogLabel.text else { return }
            guard let body = descriptionTextField.text else { return }
            
            addNotification(title: title, body: body)
            
            dismissWithAnimation()
            
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
            
            self.notificationCenter.getNotificationSettings { settings in
                if settings.authorizationStatus != .authorized {
                    print(false)
                }
            }
        }
    }
    
    func dismissWithAnimation() {
        UIView.animate(withDuration: 0.15) {
            self.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: true)
        }
    }
    
    func setCornerRadiuses() {
        self.containerView.layer.cornerRadius = 20
        self.cancelButton.layer.cornerRadius = 10
        self.addButton.layer.cornerRadius = 10
    }
    
    func setupGestures() {
        let selectGesture = UITapGestureRecognizer(target: self, action: #selector(selectDogTapped))
        selectGesture.numberOfTapsRequired = 1
        self.selectedDogLabel.isUserInteractionEnabled = true
        self.selectedDogLabel.addGestureRecognizer(selectGesture)
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


extension CreateReminderViewController: SelectDogDelegate {
    func set(name: String) {
        self.selectedDogLabel.text = name
    }
}
