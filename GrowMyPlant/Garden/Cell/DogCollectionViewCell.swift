import UIKit

class DogCollectionViewCell: UICollectionViewCell {
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    @IBOutlet weak var selectedCellNameContainerView: UIView!
    @IBOutlet weak var selectdCellNameLabel: UILabel!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var birthDateAndAgeLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCornerRadiuses()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadiuses()
    }
    
    func setCornerRadiuses() {
        self.imageContainerView.layer.cornerRadius = self.imageContainerView.frame.width / 2
        self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
    }
    

    func configure(with info: SavedDog) {
        self.selectdCellNameLabel.text = info.name
        
        let imagePath = info.imagePath
        if let image = load(fileName: imagePath) {
            self.imageView.image = image
        }
        
        self.breedLabel.text = info.breed
        
        if info.genderSegmentIndex == 0 {
            self.genderLabel.text = "Male"
        } else {
            self.genderLabel.text = "Female"
        }
        
        if info.spayed {
            self.statusImageView.image = UIImage(named: "noEggs")
        } else {
            self.statusImageView.image = UIImage(named: "eggs")
        }
                
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        let firstDate = info.birthDate
        let secondDate = Date()

        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)

        let components = calendar.dateComponents([.year], from: date1, to: date2)
        
        guard let age = components.year else { return }
        
        formatter.dateFormat = "MM-dd-yyyy"
        
        let birtDate = formatter.string(from: firstDate)
        
        self.birthDateAndAgeLabel.text = "Born: \(birtDate)\nage: \(age)"
        self.bioLabel.text = info.bio
    }
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
            return nil
        }
    }
}
