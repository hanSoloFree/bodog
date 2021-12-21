import UIKit

class TabBarController : UITabBarController, UITabBarControllerDelegate {
    
    private var homeButtonWidth: CGFloat = 80
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = 1
        setupHomeButton()
    }
    
    private func setupHomeButton() {
        let homeButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - (homeButtonWidth / 2), y: -20, width: homeButtonWidth, height: homeButtonWidth))
        homeButton.setBackgroundImage(UIImage(named: "dog"), for: .normal)

        homeButton.layer.shadowColor = UIColor.white.cgColor
        homeButton.layer.shadowOpacity = 0.1
        homeButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        homeButton.layer.cornerRadius = homeButton.frame.width / 2.6
        homeButton.backgroundColor = .clear
        self.tabBar.addSubview(homeButton)
        homeButton.addTarget(self, action: #selector(handleMoveToHome), for: .touchUpInside)
        homeButton.clipsToBounds = true
        self.view.layoutIfNeeded()
    }
    
    @objc private func handleMoveToHome(sender: UIButton) {
        self.selectedIndex = 1
    }
    
}
