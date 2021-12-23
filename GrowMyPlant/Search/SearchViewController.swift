import UIKit

class SearchViewController: UIViewController {
        
    @IBOutlet weak var searchButton: UIButton!
    
   override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        setupNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchButton.layer.cornerRadius = 15
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        guard let popoverViewController = storyboard?.instantiateViewController(withIdentifier: "SearchPopoverViewController") as? SearchPopoverViewController else { return }
        popoverViewController.modalPresentationStyle = .overFullScreen
        present(popoverViewController, animated: true) {
//            UIView.animate(withDuration: 0.15) {
//                popoverViewController.gestureZone.backgroundColor = .black.withAlphaComponent(0.8)
//                popoverViewController.tapHereLabel.alpha = 1
//            }
        }
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Find you'r dog"
        self.view.backgroundColor = .systemGray2
        let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()

        let font = UIFont(name: "Copperplate Bold", size: 40) ?? UIFont.systemFont(ofSize: 40)

        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : CustomColors.darkRed, NSAttributedString.Key.font : font]
        navBarAppearance.backgroundColor = CustomColors.darkGray
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}
