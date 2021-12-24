import UIKit

class CreateReminderViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var selectedDogLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var topGestureZone: UIView!
    @IBOutlet weak var bottomGestureZone: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization()
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
            
            NotificationManager.shared.addNotification(title: title, body: body, date: self.datePicker.date)
            
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
    
    @objc func tappedTop()  {
        dismissWithAnimation()
    }
    
    @objc func tappedBottom()  {
        dismissWithAnimation()
    }
    
    func requestAuthorization() {
        NotificationManager.shared.requestAuthorization { granted in
            if !granted {
                self.pushSettingsAlert()
            }
        }
    }
    
    func pushSettingsAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Enable notifications!", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
            
            let goToSettings = UIAlertAction(title: "Settings", style: .default) { _ in
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                self.dismiss(animated: false)
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.dismissWithAnimation()
            }
            
            alertController.addAction(goToSettings)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
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
        
        let topGesture = UITapGestureRecognizer(target: self, action: #selector(tappedTop))
        topGesture.numberOfTapsRequired = 1
        self.topGestureZone.isUserInteractionEnabled = true
        self.topGestureZone.addGestureRecognizer(topGesture)
        
        let bottomGesture = UITapGestureRecognizer(target: self, action: #selector(tappedBottom))
        bottomGesture.numberOfTapsRequired = 1
        self.bottomGestureZone.isUserInteractionEnabled = true
        self.bottomGestureZone.addGestureRecognizer(bottomGesture)
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
