import UIKit

class PendingRemindersViewController: UIViewController {
    
    var reminders: [UNNotificationContent] = [UNNotificationContent]()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var noRemindersLabel: UILabel!
    @IBOutlet weak var sadDogImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topGestureZone: UIView!
    @IBOutlet weak var bottomGestureZone: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        
        NotificationManager.shared.getPendingNotifications { contents in
            self.reminders = contents
            print(self.reminders.count)
        }
                
        let height = self.tableView.frame.height + self.mainLabel.frame.height + self.swipeLabel.frame.height + 40
        preferredContentSize = CGSize(width: self.tableView.frame.width, height: height)
        
        let cellName = String(describing: ReminderTableViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.containerView.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfEmpty()
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    @objc func tappedTop() {
        UIView.animate(withDuration: 0.15) {
            self.checkIfEmpty()
            self.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: true)
        }
    }
    
    @objc func tappedBottom() {
        UIView.animate(withDuration: 0.15) {
            self.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: true)
        }
    }
    
    func checkIfEmpty() {
        if reminders.isEmpty {
            self.sadDogImageView.isHidden = false
            self.noRemindersLabel.isHidden = false
        }
    }
    
    func setupGesture() {
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

extension PendingRemindersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: ReminderTableViewCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ReminderTableViewCell else { return UITableViewCell() }
        
        let reminder = reminders[indexPath.row]
        
        cell.configureWith(name: reminder.title, description: reminder.body, date: "12/12/21")
        
        return cell
    }
}

extension PendingRemindersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let editingRow = reminders[indexPath.row]
            self.reminders.remove(at: indexPath.row)
            
            let identifier = editingRow.title + editingRow.body
            NotificationManager.shared.removeNotification(with: identifier)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    
        checkIfEmpty()
    }
}
