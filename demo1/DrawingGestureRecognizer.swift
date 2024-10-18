
import UIKit

class DrawingGestureRecognizer: UIPanGestureRecognizer {
    var drawingPath = UIBezierPath()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            let location = touch.location(in: self.view)
            drawingPath.move(to: location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            let location = touch.location(in: self.view)
            drawingPath.addLine(to: location)
            // Trigger a redraw to reflect the drawing
            self.view?.setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        // Finalize the drawing path
    }
}
