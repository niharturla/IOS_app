import UIKit

class SettingsPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let menuItems = ["System Background", "All Documents"]
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSideMenu()
    }
    
    func setUpSideMenu() {
        // Set background color
        view.backgroundColor = .systemGray6
        
        // Set up TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Register a cell for the table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        
        // Set up TableView constraints
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - TableView Data Source and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // Navigate to System Background View Controller
            let systemBackgroundVC = SystemBackgroundViewController()
            navigationController?.pushViewController(systemBackgroundVC, animated: true)
        case 1:
            // Navigate to All Documents View Controller
            let allDocumentsVC = AllDocumentsViewController()
            navigationController?.pushViewController(allDocumentsVC, animated: true)
        default:
            break
        }
    }
}
