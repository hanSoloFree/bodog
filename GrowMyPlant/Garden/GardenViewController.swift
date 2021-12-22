import UIKit

class GardenViewController: UIViewController, UITabBarDelegate {
    
    var dogs: [SavedDog]!
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dogs = DataManager.shared.get()

        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = .systemGray2
        setupNavBar()
        self.navigationController?.navigationBar.setNeedsLayout()
        let cellName = String(describing: DogCollectionViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dogs = DataManager.shared.get()
    }
    
    
    private func setupNavBar() {
        navigationItem.title = "My Dogs"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem?.imageInsets = .init(top: 6, left: 0, bottom: 0, right: 0)
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        let font = UIFont(name: "Copperplate Bold", size: 40) ?? UIFont.systemFont(ofSize: 40)

        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : CustomColors.darkRed, NSAttributedString.Key.font : font]
        
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : CustomColors.darkRed, NSAttributedString.Key.font : font]
        
        navBarAppearance.backgroundColor = CustomColors.darkGray
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    //MARK: IMAGE
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    //MARK: IMAGE

}


extension GardenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: DogCollectionViewCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? DogCollectionViewCell else { return UICollectionViewCell() }
        
        
        return cell
    }
}

extension GardenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.frame.width
        let height = self.collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
}


