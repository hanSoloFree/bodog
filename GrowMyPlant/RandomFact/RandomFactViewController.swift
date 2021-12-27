import UIKit

class RandomFactViewController: UIViewController {
    
    var showFact: Bool = false
    
    @IBOutlet weak var label: UILabel! {
        didSet {
            self.preferredContentSize = CGSize(width: self.label.bounds.width,
                                               height: self.label.bounds.height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
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
