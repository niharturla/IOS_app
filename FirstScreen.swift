import UIKit
import PDFKit
import UniformTypeIdentifiers

class HomeScreen: UIViewController, UIDocumentPickerDelegate {
    
    let card = CardView()
    
    func setUpCard() {
        card.translatesAutoresizingMaskIntoConstraints = false
        card.configureCard(withImage: UIImage(systemName: "gearshape")!, title: "Settings", description: "This is the settings page.")
        
        // Add the card to the view
        view.addSubview(card)
        
        // Set up constraints for the card
        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.widthAnchor.constraint(equalToConstant: 300),
            card.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCard()
        setUpToolBar()
        view.backgroundColor = .systemGray4
        title = "Directors Intent App"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setUpToolBar() {
            // Create a toolbar
            let toolbar = UIToolbar()
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(toolbar)
            
            // Add constraints to position the toolbar at the bottom
            NSLayoutConstraint.activate([
                toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                toolbar.heightAnchor.constraint(equalToConstant: 50)  // Set toolbar height
            ])
        
        toolbar.backgroundColor = .systemGray2
            
            // Create a flexible space for left and right alignment
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            // Create an empty button item to hold space for the floating button
            let emptySpace = UIBarButtonItem(customView: UIView())
            
            // Add the flexible spaces and empty space to toolbar
            toolbar.setItems([flexibleSpace, emptySpace, flexibleSpace], animated: false)
            
            // Create the button that will pop out of the toolbar
            let popOutButton = UIButton(type: .custom)
            popOutButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            popOutButton.tintColor = .systemBlue
            popOutButton.addTarget(self, action: #selector(selectFiles), for: .touchUpInside)
    
            
            // Add the button to the view (but it will visually "pop out" from the toolbar)
            view.addSubview(popOutButton)
            
            // Disable auto resizing mask translation
            popOutButton.translatesAutoresizingMaskIntoConstraints = false
            
            // Set constraints to make the button pop out of the toolbar
            NSLayoutConstraint.activate([
                popOutButton.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor),
                popOutButton.bottomAnchor.constraint(equalTo: toolbar.topAnchor, constant: 10), // Button "pops out" 25 points above the toolbar
                popOutButton.widthAnchor.constraint(equalToConstant: 200),  // Button width
                popOutButton.heightAnchor.constraint(equalToConstant: 200)  // Button height
            ])
            
            /* Optionally, you can set the button's corner radius to make it fully circular
            popOutButton.layer.cornerRadius = 35
            popOutButton.layer.shadowColor = UIColor.black.cgColor
            popOutButton.layer.shadowOpacity = 0.2
            popOutButton.layer.shadowOffset = CGSize(width: 0, height: 4)
            popOutButton.layer.shadowRadius = 10 */
        }
    @objc func selectFiles() {
        let types = [UTType.pdf]  // Only allow PDF selection
        let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true)
    }

    // MARK: - UIDocumentPickerDelegate Methods
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        
        // Navigate to DownloaderViewController and pass the selected PDF file
        let downloaderVC = DownloaderViewController()
        downloaderVC.selectedPDFURL = selectedFileURL
        navigationController?.pushViewController(downloaderVC, animated: true)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
    
    @objc func selectSettingsCard() {
        let settingsVC = SettingsPageViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    
}
