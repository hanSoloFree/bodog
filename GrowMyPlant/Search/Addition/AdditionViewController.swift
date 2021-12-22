import UIKit

class AdditionViewController: UIViewController {
    
    var defaultImage: UIImage?
    var defaultBreed: String?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dogImageFrameView: UIView!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var setDefaultPhotoLabel: UILabel!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var spayedSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadiuses()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func clearAllButtonPressed(_ sender: UIButton) {
        
    }
    
    func setupDefaults() {
        if let breed = self.defaultBreed {
            self.breedLabel.text = breed
        }
        
        self.spayedSwitch.isOn = false
        
        let setDefaultImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(setDefaultImage))
        self.setDefaultPhotoLabel.isUserInteractionEnabled = true
        self.setDefaultPhotoLabel.addGestureRecognizer(setDefaultImageTapGesture)
        
        
        let setImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(setImage))
        self.dogImageView.isUserInteractionEnabled = true
        self.dogImageView.addGestureRecognizer(setImageTapGesture)
        
    }
    
    func setCornerRadiuses() {
        self.containerView.layer.cornerRadius = 20
        
        self.dogImageFrameView.layer.cornerRadius = dogImageFrameView.frame.width / 2
        self.dogImageView.layer.cornerRadius = dogImageView.frame.width / 2
        
        let buttonCornerRadius: CGFloat = 10
        self.saveButton.layer.cornerRadius = buttonCornerRadius
        self.cancelButton.layer.cornerRadius = buttonCornerRadius
        self.clearAllButton.layer.cornerRadius = buttonCornerRadius
    }
    
    @objc func setDefaultImage() {
        if let defaultImage = defaultImage {
            self.dogImageView.image = defaultImage
            self.dogImageFrameView.isHidden = false
        }
    }
    
    @objc func setImage() {
        //
    }
    
    
}
