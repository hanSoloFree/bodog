import UIKit

class RemoveAlertViewController: UIViewController {
    
    var text: String!
    var deleteAction: (()->Void)?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = text
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadiuses()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeButtonPerssed(_ sender: UIButton) {
        deleteAction?()
        self.view.backgroundColor = .black.withAlphaComponent(0)
        self.dismiss(animated: true)
    }
    
    func setCornerRadiuses() {
        self.containerView.layer.cornerRadius = 10
        self.cancelButton.layer.cornerRadius = 10
        self.removeButton.layer.cornerRadius = 10
    }
}
