import Foundation
import UIKit

class ScannerController: UIViewController {
    private var ean: String?
     private var products: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
               label.center = CGPoint(x: 160, y: 285)
               label.textAlignment = .center

               // TODO this ean will be return by Image->Text method
               GetProductByEAN(ean: "5017726180034",completionHandler:{ [weak self] (products) in
                   self?.products = products
                   DispatchQueue.main.async {
                       label.text = products[0].name
                   }
               })
               self.view.addSubview(label)
    }
}
