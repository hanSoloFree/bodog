import UIKit

class SearchPopoverViewController: UIViewController {
    
    var list: [List] = [List]()
    var filteredList:[List] = [List]()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gestureZone: UIView!
    
    
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
        self.gestureZone.addGestureRecognizer(tap)
    }
    
    func getData() {
        if self.list.isEmpty {
            NetworkManager.shared.requestListOfBreeds { list in
                self.filteredList = list
                self.list = list
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func tap() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension SearchPopoverViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredList.removeAll()
        
        if searchText == "" {
            filteredList = list
        }
        
        for item in list {
            guard let name = item.name else { return }
            if name.uppercased().contains(searchText.uppercased()) {
                filteredList.append(item)
            }
        }
        
        self.collectionView.reloadData()
    }
}


extension SearchPopoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell()}
        let info = self.filteredList[indexPath.item]
        cell.configure(with: info)
        return cell
    }
}


extension SearchPopoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let identifier = String(describing: DetailsViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let detailsViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? DetailsViewController else { return }
        
        detailsViewController.details = filteredList[indexPath.item]
        
        detailsViewController.modalPresentationStyle = .overFullScreen
        present(detailsViewController, animated: true) {
            UIView.animate(withDuration: 0.15) {
                detailsViewController.view.backgroundColor = .black.withAlphaComponent(0.4)
            }
        }
    }
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
