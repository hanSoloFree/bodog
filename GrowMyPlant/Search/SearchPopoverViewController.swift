import UIKit

class SearchPopoverViewController: UIViewController {
    
    var list: [List] = [List]()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setupDismissGesture()
        
        let cellName = String(describing: SearchCollectionViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellName)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }
    
    func setupDismissGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(tap)
    }
    
    func getData() {
        if self.list.isEmpty {
            NetworkManager.shared.requestListOfBreeds { list in
                self.list = list
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func tap() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension SearchPopoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell()}
        let info = self.list[indexPath.item]
        cell.configure(with: info)
        return cell
    }
}

extension SearchPopoverViewController: UICollectionViewDelegate {
    // didSelect ...
}


extension SearchPopoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.collectionView.frame.width - 24) / 2
        let height = width * 0.85
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
