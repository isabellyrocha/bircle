import Foundation
import UIKit

class WalletController: UIViewController {
    
    @IBOutlet var earning: UILabel!
    @IBOutlet var pending: UILabel!
    @IBOutlet var balance: UILabel!
    @IBOutlet var refer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        balance.layer.borderColor = UIColor.black.cgColor
        balance.layer.borderWidth = 1
        balance.layer.cornerRadius = 8
        refer.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Wallet"
    }
    
    @IBAction func referAFriend(_ sender: Any) {
        let referAlert = UIAlertController(title: "Referral Bonus", message: "Let your friends know about Bircle! Use #hackzurich", preferredStyle: UIAlertController.Style.alert)

        referAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
        }))

        referAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))

        present(referAlert, animated: true, completion: nil)
        
        let alert = UIAlertController(title: "Let your friends know about Bircle!", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}
