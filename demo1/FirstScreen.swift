import UIKit
import PDFKit
import UniformTypeIdentifiers

class HomeScreen: UIViewController, UIDocumentPickerDelegate {
    
    let card = CardView()
    let upload_card = CardView()
    
    func setUpCard() {
        card.translatesAutoresizingMaskIntoConstraints = false
        card.configureCard(withImage: UIImage(systemName: "gearshape")!, title: "Settings", description: "This is the settings page.")
        
        // Add the first card to the view
        view.addSubview(card)
        
        // Set up constraints for the first card
        NSLayoutConstraint.activate([
            // Anchor the card's right edge to the right edge of the view with a margin
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    // Position the card below the top safe area
            card.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
     
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectSettingsCard))
        let tapUpload = UITapGestureRecognizer(target: self, action: #selector(selectFiles))
        card.isUserInteractionEnabled = true
        card.addGestureRecognizer(tapGesture)
        
        // Configure the second card
        upload_card.translatesAutoresizingMaskIntoConstraints = false
        upload_card.configureCard(withImage: UIImage(systemName: "paperclip")!, title: "Upload", description: "Click here to upload PDF")
        
        view.addSubview(upload_card)
        
        // Set up constraints for the second card to be below the first card
        NSLayoutConstraint.activate([
            // Align the second card to the same trailing edge as the first card
            upload_card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    // Position the card below the top safe area
            upload_card.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 20), // 20 points of spacing between the cards
     
          
        ])
        upload_card.addGestureRecognizer(tapUpload)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCard()
        view.backgroundColor = .systemGray4
        title = "Directors Intent App"
        navigationController?.navigationBar.prefersLargeTitles = true
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
