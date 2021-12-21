import UIKit

class GardenViewController: UIViewController, UITabBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = .systemGray2
        setupNavBar()
        self.navigationController?.navigationBar.setNeedsLayout()
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
}
