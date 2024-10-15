//
//  FirstScreen.swift
//  demo1
//
//  Created by Nihar Turlapati on 10/14/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class FirstScreen: UIViewController, UIDocumentPickerDelegate {
    
    let nextButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // set the background of the screen to mint color
        setUpButton()
        view.backgroundColor = .systemGray
        title = "Directors Intent App"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setUpButton() {
        view.addSubview(nextButton)
        
        nextButton.configuration = .filled()
        nextButton.configuration?.baseBackgroundColor = .systemGreen
        nextButton.configuration?.title = "Upload"
        
        nextButton.addTarget(self, action: #selector(selectFiles), for: .touchUpInside)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func selectFiles() {
        let types = UTType.types(tag: "json",
                                 tagClass: UTTagClass.filenameExtension,
                                 conformingTo: nil)
        let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true)
    }
    
    // MARK: - UIDocumentPickerDelegate methods
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // Handle file selection here
        guard let selectedFileURL = urls.first else { return }
        print("Selected file URL: \(selectedFileURL)")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }

}
