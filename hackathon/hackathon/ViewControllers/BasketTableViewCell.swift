import UIKit

class BasketTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabelVar: UILabel!
    @IBOutlet var stepper: UIStepper!
    
    static let identifier = "BasketTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "BasketTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with product: Product){
        self.nameLabelVar?.text = "\(product.name)"
        print("configured")
        print(self.nameLabelVar)
    }
    
}
