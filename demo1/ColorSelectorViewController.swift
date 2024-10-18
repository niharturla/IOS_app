//
//  ColorSelectorViewController.swift
//  demo1
//
//  Created by Nihar Turlapati on 10/17/24.
//


import UIKit

class ColorSelectorViewController: UIViewController {
    
    var colorSelectionHandler: ((UIColor) -> Void)?  // Closure to return selected color
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpColorButtons()
    }

    // Setup buttons for selecting different colors
    func setUpColorButtons() {
        let colors: [UIColor] = [.red, .blue, .green, .black, .orange]
        let buttonWidth: CGFloat = 50
        let spacing: CGFloat = 20
        let totalWidth = (buttonWidth + spacing) * CGFloat(colors.count) - spacing
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for color in colors {
            let colorButton = UIButton()
            colorButton.backgroundColor = color
            colorButton.layer.cornerRadius = buttonWidth / 2
            colorButton.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(colorButton)
        }
        
        view.addSubview(stackView)
        
        // Set constraints for color buttons
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: totalWidth),
            stackView.heightAnchor.constraint(equalToConstant: buttonWidth)
        ])
    }

    @objc func colorSelected(_ sender: UIButton) {
        guard let selectedColor = sender.backgroundColor else { return }
        colorSelectionHandler?(selectedColor)  // Pass selected color back
        dismiss(animated: true, completion: nil)
    }
}
