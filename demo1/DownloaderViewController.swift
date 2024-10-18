import UIKit
import PDFKit

class DownloaderViewController: UIViewController {

    var selectedPDFURL: URL?  // To hold the selected PDF URL
    var pdfView: PDFView?
    var currentDrawingColor: UIColor = .black  // Default drawing color
    var markerView: UIView?  // A circular view representing the marker cursor

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Set up PDFView to display the selected PDF
        if let pdfURL = selectedPDFURL {
            setUpPDFView(pdfURL: pdfURL)
        }
        
        // Set up toolbar with buttons
        setUpToolbar()
    }

    func setUpPDFView(pdfURL: URL) {
        let pdfDocument = PDFDocument(url: pdfURL)
        pdfView = PDFView(frame: self.view.bounds)
        pdfView?.document = pdfDocument
        pdfView?.autoScales = true
        self.view.addSubview(pdfView!)
    }

    // MARK: - Toolbar Setup
    func setUpToolbar() {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let drawButton = UIBarButtonItem(image: UIImage(systemName: "pencil.tip"), style: .done, target: self, action: #selector(selectDrawingColor))
        let downloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down.to.line.alt"), style: .done, target: self, action: #selector(downloadPDF))
        let clearButton = UIBarButtonItem(image: UIImage(systemName: "eraser.fill"), style: .done, target: self, action: #selector(clearDrawing))

        
        toolbar.items = [drawButton, UIBarButtonItem.flexibleSpace(), downloadButton, UIBarButtonItem.flexibleSpace(), clearButton]
        
        view.addSubview(toolbar)
        
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Toolbar Actions
    @objc func selectDrawingColor() {
        let colorSelectorVC = ColorSelectorViewController()
        colorSelectorVC.colorSelectionHandler = { selectedColor in
            self.currentDrawingColor = selectedColor  // Set the chosen color
            self.startDrawing()  // Start drawing with the chosen color
        }
        present(colorSelectorVC, animated: true, completion: nil)
    }

    @objc func startDrawing() {
        print("Drawing mode enabled")
        // Enable drawing on the PDFView with the selected color
        let drawingGestureRecognizer = DrawingGestureRecognizer(target: self, action: #selector(handleDrawing(_:)))
        pdfView?.addGestureRecognizer(drawingGestureRecognizer)
        
        // Add a marker view that will follow the cursor
        addMarkerView()
    }

    func addMarkerView() {
        // Create a circular view to act as the marker
        let markerDiameter: CGFloat = 20
        let marker = UIView(frame: CGRect(x: 0, y: 0, width: markerDiameter, height: markerDiameter))
        marker.layer.cornerRadius = markerDiameter / 2
        marker.backgroundColor = currentDrawingColor.withAlphaComponent(0.8)  // Semi-transparent color
        marker.isHidden = true  // Initially hidden until touch begins
        marker.layer.borderWidth = 1
        marker.layer.borderColor = UIColor.darkGray.cgColor

        view.addSubview(marker)
        markerView = marker
    }

    @objc func handleDrawing(_ gesture: DrawingGestureRecognizer) {
        guard let pdfView = gesture.view as? PDFView else { return }
        let location = gesture.location(in: pdfView)

        switch gesture.state {
        case .began, .changed:
            // Move the marker view to the touch location
            markerView?.center = location
            markerView?.isHidden = false  // Show marker when drawing starts
            
            // Handle drawing logic here
            let path = UIBezierPath()
            path.move(to: location)
            
            if let shapeLayer = pdfView.layer.sublayers?.compactMap({ $0 as? CAShapeLayer }).first {
                path.addLine(to: location)
                shapeLayer.path = path.cgPath
                shapeLayer.strokeColor = currentDrawingColor.cgColor  // Use selected color
            }
            
        case .ended:
            // Hide the marker view when drawing ends
            markerView?.isHidden = true
            
        default:
            break
        }
    }

    @objc func downloadPDF() {
        print("Download PDF")
        // Add logic to save/export the modified PDF
    }

    @objc func clearDrawing() {
        print("Clear Drawing")
        // Clear any drawings on the PDF
        if let shapeLayer = pdfView?.layer.sublayers?.compactMap({ $0 as? CAShapeLayer }).first {
            shapeLayer.path = nil
        }
    }
}
