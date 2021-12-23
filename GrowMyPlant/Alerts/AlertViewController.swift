import UIKit

class AlertViewController: UIViewController {
    
    var text: String!
    var savingDelegate: SavingDelegate?
    
    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { self.dismiss(animated: true) {
                guard self.text != "Cleaned!" else { return }
                self.savingDelegate?.dismiss()
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadiuses()
    }
    
    func setCornerRadiuses() {
        self.labelContainerView.layer.cornerRadius = 10
    }
}
