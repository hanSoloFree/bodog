import UIKit

class RandomFactViewController: UIViewController {
    
    var showFact: Bool = false
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        preferredContentSize = CGSize(width: label.frame.width,
                                      height: label.frame.height)
        if showFact {
        NetworkManager.shared.requestFact { fact in
            self.label.text = fact
        }
        } else {
            self.label.font = UIFont(name: "Courier New Bold", size: 18)
            self.label.textAlignment = .center
            self.label.text = "Double tap to see a random fact!"
        }
    }
    
}
