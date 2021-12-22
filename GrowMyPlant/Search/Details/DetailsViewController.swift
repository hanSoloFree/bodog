import UIKit

class DetailsViewController: UIViewController {
    
    var details: List?
    var additionDelegate: AdditionDelegate?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var lifeSpanLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UILabel!
    @IBOutlet weak var bredForLabel: UILabel!
    @IBOutlet weak var breedGroupLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetails()
        setupGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addButton.layer.cornerRadius = 15
        self.containerView.layer.cornerRadius = 15
        self.dogImageView.layer.cornerRadius = 10
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: AdditionViewController.self)
        guard let additionViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? AdditionViewController else { return }
        additionViewController.modalPresentationStyle = .overFullScreen
        additionViewController.defaultImage = dogImageView.image
        additionViewController.defaultBreed = breedLabel.text
        
        self.dismiss(animated: true) {
            self.additionDelegate?.present(additionViewController: additionViewController)
        }
    }
    
    func setupDetails() {
        guard let details = details else { return }

        if let dogImageURL  = details.image?.url {
            ImageManager.shared.setImage(for: dogImageView, url: dogImageURL)
        }
    
        if let lifeSpan = details.lifeSpan {
            lifeSpanLabel.text = lifeSpan
        }
        
        if let height = details.height?.metric {
            heightLabel.text = height + "cm"
        }
        
        if let weight = details.weight?.metric {
            weightLabel.text = weight + "kg"
        }
        
        if let breed  = details.name {
            breedLabel.text = breed
        }
        
        if let temperament = details.temperament {
            temperamentLabel.text = temperament
        }
        
        if let bredFor = details.bredFor {
            bredForLabel.text = bredFor
        }
        
        if let breedGroup = details.breedGroup {
            breedGroupLabel.text = breedGroup
        }
    }
    
    func setupGesture() {
        let tap =  UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tap() {
        self.view.backgroundColor = .black.withAlphaComponent(0)
        self.dismiss(animated: true, completion: nil)
    }
    
}
