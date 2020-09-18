import Foundation
import UIKit

class BasketController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Gesture Setup
        let swipeLeft = UISwipeGestureRecognizer()
        let swipeRight = UISwipeGestureRecognizer()
        
        swipeLeft.direction = .left
        swipeRight.direction = .right
        
        super.view.addGestureRecognizer(swipeLeft)
        super.view.addGestureRecognizer(swipeRight)
        
        swipeLeft.addTarget(self, action: #selector(swipe(sender:)))
        swipeRight.addTarget(self, action: #selector(swipe(sender:)))
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Re-Bottle"
    }
    
    @objc func swipe(sender: UISwipeGestureRecognizer){
        switch sender.direction {
        case .left:
            let consumptionController = ConsumptionController()
            self.navigationController!.pushViewController(consumptionController, animated: true)
        case .right:
            let barcodeController = BarcodeController()
            barcodeController.modalPresentationStyle = .fullScreen
            self.navigationController!.pushViewControllerFromLeft(controller: barcodeController)
        default:
            break
        }
    }

}

extension UINavigationController {
    func pushViewControllerFromLeft(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
    
    func popViewControllerToLeft() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
}
