import Photos
import PhotosUI
import UIKit

class AdditionViewController: UIViewController {
    
    var defaultImage: UIImage?
    var defaultBreed: String?
    
    var selectedImage: UIImage?
    var newImageSet: Bool = false
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
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
        
        if self.nameTextField.text != "" && newImageSet  {
            
            guard let name = self.nameTextField.text else { return }
            guard let image = self.dogImageView.image else { return }
            guard let imagePath =  save(image: image, fileName: name) else { return }
            guard let breed = self.breedLabel.text else { return }
            let bio = self.bioTextField.text
            
            let object = SavedDog()
            object.birthDate = self.birthDatePicker.date
            object.genderSegmentIndex = self.genderSegmentControl
                .selectedSegmentIndex
            object.imagePath = imagePath
            object.name = name
            object.bio = bio ?? "No bio."
            object.breed = breed
            object.spayed = self.spayedSwitch.isOn
            
            if DataManager.shared.save(object: object) {
                let alert = AlertService.shared.alert("Saved!")
                alert.savingDelegate = self
                self.present(alert, animated: true)
            } else {
                let alert = AlertService.shared.alert("You have already saved this dog!\nCheck for information you've typed!")
                self.present(alert, animated: true)
            }
            
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) {
            self.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func clearAllButtonPressed(_ sender: UIButton) {
        
        if self.nameTextField.text != "" || self.bioTextField.text != "" || self.newImageSet || self.spayedSwitch.isOn {
            
            
            self.dogImageFrameView.backgroundColor = .systemGray
            self.dogImageView.image = UIImage(named: "camera")
            
            let currentDate = Date()
            self.birthDatePicker.setDate(currentDate, animated: true)
            
            self.genderSegmentControl.selectedSegmentIndex = 0
            
            self.nameTextField.text = ""
            self.bioTextField.text = ""
            
            self.spayedSwitch.isOn = false
            
            self.newImageSet = false
            
            let alert = AlertService.shared.alert("Cleaned")
            present(alert, animated: true)
        }
    }
    
    private func save(image: UIImage, fileName: String) -> String? {
        let fileName = fileName
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
            return fileName
        } else {
            print("Error saving image")
            return nil
        }
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
            self.dogImageFrameView.backgroundColor = .white
            
            self.newImageSet = true
        }
    }
    
    @objc func setImage() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        
        let photoPickerViewController = PHPickerViewController(configuration: config)
        photoPickerViewController.delegate = self
        
        present(photoPickerViewController, animated: true)
    }
}

extension AdditionViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let group = DispatchGroup()
        
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                
                defer {
                    group.leave()
                }
                
                guard let image = reading as? UIImage, error == nil else { return }
                self.selectedImage = image
            }
        }
        
        group.notify(queue: .main) {
            guard self.selectedImage != nil else { return }
            self.dogImageView.image = self.selectedImage
            self.dogImageFrameView.backgroundColor = .white
            self.newImageSet = true
        }
        
    }
}

extension AdditionViewController: SavingDelegate {
    func dismiss() {
        self.view.backgroundColor = .black.withAlphaComponent(0)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
