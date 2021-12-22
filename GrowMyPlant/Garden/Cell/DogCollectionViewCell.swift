import UIKit

class DogCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(img: UIImage) {
        self.img.image = img
    }
}
